package br.com.pdsars.guiasapi.bffApp.controller;

import br.com.pdsars.guiasapi.bffApp.service.BffAppGtsService;
import br.com.pdsars.guiasapi.dto.ResponseDTO;
import br.com.pdsars.guiasapi.dto.gts.GTSDTO;
import br.com.pdsars.guiasapi.dto.gts.TipoSubprodutoDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/bff-app/gts")
public class BffAppGtsController {
    private final BffAppGtsService gtsService;

    public BffAppGtsController(BffAppGtsService gtsService) {
        this.gtsService = gtsService;
    }

    @PostMapping
    public ResponseDTO<GTSDTO> create(@RequestParam("gtsForm") String gtsForm,
                                      @RequestParam(value = "uuid_sync", required = false) UUID uuid_sync,
                                      @RequestParam(value = "data_hora_preenchimento_app", required = false) String data_hora_preenchimento_app
                                      ) {
        try {
            return ResponseEntity.ok(gtsService.create(gtsForm, uuid_sync, data_hora_preenchimento_app)).getBody();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @GetMapping
    public ResponseDTO<List<GTSDTO>> getAll() {
        List<GTSDTO> gtsdtos = gtsService.findAll();
        return new ResponseDTO<>("Sucesso", ResponseDTO.Status.SUCCESS, gtsdtos);
    }

    @GetMapping("/tipos_subprodutos")
    public ResponseDTO<List<TipoSubprodutoDTO>> getAllTiposSubProdutos() {
        List<TipoSubprodutoDTO> tipoSubprodutoDTOS = gtsService.findAllTiposSubprodutos();
        return new ResponseDTO<>("Sucesso", ResponseDTO.Status.SUCCESS, tipoSubprodutoDTOS);
    }

    @GetMapping("/pdf/{uuid}")
    public ResponseEntity<byte[]> getPDF(@PathVariable("uuid") String uuid) {
        return ResponseEntity.ok(this.gtsService.getPDF(uuid));
    }
}
