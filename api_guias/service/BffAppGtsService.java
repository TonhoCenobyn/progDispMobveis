package br.com.pdsars.guiasapi.bffApp.service;

import br.com.pdsars.guiasapi.dto.ResponseDTO;
import br.com.pdsars.guiasapi.dto.form.gts.DestinoForm;
import br.com.pdsars.guiasapi.dto.form.gts.GTSForm;
import br.com.pdsars.guiasapi.dto.form.gts.SubprodutoForm;
import br.com.pdsars.guiasapi.dto.gts.GTSDTO;
import br.com.pdsars.guiasapi.dto.gts.TipoSubprodutoDTO;
import br.com.pdsars.guiasapi.error.NotFoundException;
import br.com.pdsars.guiasapi.model.gts.Destino;
import br.com.pdsars.guiasapi.model.gts.GTS;
import br.com.pdsars.guiasapi.model.gts.Subproduto;
import br.com.pdsars.guiasapi.model.gts.TipoSubproduto;
import br.com.pdsars.guiasapi.repository.external.EmpresaRepository;
import br.com.pdsars.guiasapi.repository.external.EstabelecimentoRepository;
import br.com.pdsars.guiasapi.repository.external.UsuarioRepository;
import br.com.pdsars.guiasapi.repository.gts.GTSRepository;
import br.com.pdsars.guiasapi.repository.gts.TipoSubprodutoRepository;
import br.com.pdsars.guiasapi.service.common.PDFService;
import br.com.pdsars.guiasapi.service.external.UsuarioVinculoService;
import br.com.pdsars.guiasapi.service.notification.GTSNotificationService;
import br.com.pdsars.guiasapi.utils.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import org.apache.logging.log4j.util.Strings;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import javax.transaction.Transactional;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class BffAppGtsService {
    private final GTSRepository gtsRepository;
    private final TipoSubprodutoRepository tipoSubprodutoRepository;
    private final EmpresaRepository empresaRepository;
    private final EstabelecimentoRepository estabelecimentoRepository;
    private final UsuarioRepository usuarioRepository;
    private final PDFService pdfService;
    private final UsuarioVinculoService usuarioVinculoService;
    private final GTSNotificationService gtsNotificationService;

    public BffAppGtsService(
            GTSRepository gtsRepository,
            TipoSubprodutoRepository tipoSubprodutoRepository,
            EmpresaRepository empresaRepository,
            UsuarioRepository usuarioRepository,
            PDFService pdfService,
            EstabelecimentoRepository estabelecimentoRepository,
            UsuarioVinculoService usuarioVinculoService,
            GTSNotificationService gtsNotificationService
            ){
        this.gtsRepository = gtsRepository;
        this.tipoSubprodutoRepository = tipoSubprodutoRepository;
        this.empresaRepository = empresaRepository;
        this.usuarioRepository = usuarioRepository;
        this.pdfService = pdfService;
        this.estabelecimentoRepository = estabelecimentoRepository;
        this.usuarioVinculoService = usuarioVinculoService;
        this.gtsNotificationService = gtsNotificationService;
    }

    @Transactional
    public ResponseDTO<GTSDTO> create(String form, UUID uuid_sync, String data_hora_preenchimento_app) throws NotFoundException, JsonProcessingException {
        //Cria um JsonMapper (subtipo de ObjectMapper) configurado para lançar erro caso haja tokens extras no JSON ou propriedades desconhecidas.
        JsonMapper om = JsonMapper.builder().enable(DeserializationFeature.FAIL_ON_TRAILING_TOKENS).disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES).build();

        try {
            //Evita duplicidade de sincronização offline. Se o uuid_sync já existe no banco, lança exceção.
            if (uuid_sync != null && Strings.isNotEmpty(data_hora_preenchimento_app)) {
                System.out.println("GTS já sincronizada");
                //boolean alreadyExists = gtsRepository.offlineSyncAlreadyExists(uuid_sync);
                //if(alreadyExists) {
                //throw new AlreadyReportedException("Auto já sincronizado", "Auto já sincronizado");
                //}
            }


            //Converte o JSON da requisição em um objeto AutoForm.
            GTSForm gtsForm = om.readValue(form, GTSForm.class);
            gtsForm.setOrgaoEmissor("RS");

            /*List<TipoSubproduto> tiposSubproduto = tipoSubprodutoRepository.findAllByIdIn(
                    gtsForm.getSubprodutos().stream()
                            .map(SubprodutoForm::getId)
                            .toList()
            ).orElseThrow(
                    () -> new NotFoundException("Um ou mais tipos de subproduto não foram encontrados")
            );*/

            Destino destino = Destino.builder()
                    .cep(gtsForm.getDestino().getCep())
                    .cnpjCpf(gtsForm.getDestino().getCnpjCpf())
                    .nome(gtsForm.getDestino().getNome())
                    .logradouro(gtsForm.getDestino().getLogradouro())
                    .numero(gtsForm.getDestino().getNumero())
                    .complemento(gtsForm.getDestino().getComplemento())
                    .cidade(gtsForm.getDestino().getCidade())
                    .uf(gtsForm.getDestino().getUf())
                    .build();

            String dataValidadeIso = gtsForm.getDataValidade(); // ex: "2025-07-10T00:00:00.000"
            String onlyDate = dataValidadeIso.split("T")[0];   // => "2025-07-10"

            GTS gts = GTS.builder()
                    //TODO: Implementar lógica para gerar série
                    .descricao(gtsForm.getDescricao())
                    .lacres(gtsForm.getLacres())
                    .orgaoEmissor(gtsForm.getOrgaoEmissor())
                    .observacao(gtsForm.getObservacao())
                    .dataValidade(Date.valueOf(onlyDate)) //erro de conversao
                    //.transporte(GTS.TipoTransporte.valueOf(gtsForm.getTransporte()))  erro de nao haver enum "A Pé" (seria A_PE)
                    .transporte(GTS.TipoTransporte.valueOf(gtsForm.getTransporte()))
                    .origem(empresaRepository.getById(User.getCompanyIdUser()))
                    .usuario(usuarioRepository.getById(User.getIdUser()))
                    .destino(destino)
                    .build();

            TipoSubproduto tipoSubproduto = tipoSubprodutoRepository.getById(3L);

            List<Subproduto> subprodutos = gtsForm.getSubprodutos().stream()
                    .map(subprodutoForm -> Subproduto.builder()
                            .quantidade(subprodutoForm.getQuantidade())
                            .lote(subprodutoForm.getLote())
                            .peso(subprodutoForm.getPeso())
                            .tratamento(subprodutoForm.getTratamento())
                            .finalidade(subprodutoForm.getFinalidade())
                            .tipoSubproduto(tipoSubproduto) // <-- ajuste necessário aqui
                            .unidadeMedida(subprodutoForm.getUnidadeMedida())
                            .gts(gts)
                            .build()
                    )
                    .toList();


            gts.setSubprodutos(subprodutos);

            //Registra os dados de sincronização offline. (TEM QUE CRIAR UUID_SYNC E DATA_HORA_SYNC
            /*
            gts.setUuid_sync(uuid_sync);
            gts.setData_hora_sync(LocalDateTime.now());
            */

            GTS gtsSaved = gtsRepository.saveAndFlush(gts);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<GTSDTO> findAll() {
        List<GTS> gts = gtsRepository.findAllByOrigem_Id(User.getCompanyIdUser());
        System.out.println(GTSDTO.from(gts));
        return GTSDTO.from(gts);
    }

    public List<TipoSubprodutoDTO> findAllTiposSubprodutos() {
        List<TipoSubproduto> tiposSubprodutos = tipoSubprodutoRepository.findAll();
        return TipoSubprodutoDTO.from(tiposSubprodutos);
    }

    public byte[] getPDF(String uuid) {
        return pdfService.baixarGTS(uuid);
    }
}
