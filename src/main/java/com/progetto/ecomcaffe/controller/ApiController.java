package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.service.ProdottoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/prodotto")
public class ApiController {
    private final ProdottoService prodottoService;

    @Autowired
    public ApiController(ProdottoService prodottoService) {
        this.prodottoService = prodottoService;
    }

    // Endpoint per incrementare il numero di visualizzazioni di un prodotto
    // Consente richieste Cross-Origin da qualsiasi dominio
    @CrossOrigin(origins = "*")
    @PostMapping("/{id}/incrementaVisualizzazioni")
    public void incrementaVisualizzazioni(@PathVariable int id) {
        prodottoService.incrementaVisualizzazioni(id);
    }
}
