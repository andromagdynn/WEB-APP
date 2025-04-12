package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.Categoria;
import com.progetto.ecomcaffe.model.Brand;
import com.progetto.ecomcaffe.model.Prodotto;
import com.progetto.ecomcaffe.service.CategoriaService;
import com.progetto.ecomcaffe.service.BrandService;
import com.progetto.ecomcaffe.service.ProdottoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeController {
    private final ProdottoService prodottoService;
    private final CategoriaService categoriaService;
    private final BrandService brandService;

    @Autowired
    public HomeController(ProdottoService prodottoService, CategoriaService categoriaService, BrandService brandService) {
        this.prodottoService = prodottoService;
        this.categoriaService = categoriaService;
        this.brandService = brandService;
    }

    // ============================================================
    // Sezione: Home
    // ============================================================

    // GET: /
    // Recupera prodotti filtrati, in vetrina, categorie, marchi e prodotti più visti,
    // aggiungendoli al Model per la visualizzazione della home.
    @GetMapping("/")
    public String home(Model model,
                       @RequestParam(required = false) String categoria,
                       @RequestParam(required = false) String brand,
                       @RequestParam(required = false) String ricerca) {

        List<Prodotto> prodotti = prodottoService.getProdottiFiltrati(categoria, brand, ricerca);
        List<Prodotto> vetrina = prodottoService.getProdottiInVetrina();
        List<Categoria> categorie = categoriaService.getAllCategorie();
        List<Brand> marchi = brandService.getAllBrands();
        List<Prodotto> prodottiPiuVisti = prodottoService.getProdottiPiuVisti();

        model.addAttribute("prodotti", prodotti);
        model.addAttribute("prodottiVetrina", vetrina);
        model.addAttribute("categorie", categorie);
        model.addAttribute("brand", marchi);
        model.addAttribute("prodottiPiuVisti", prodottiPiuVisti);

        return "home";
    }
}
