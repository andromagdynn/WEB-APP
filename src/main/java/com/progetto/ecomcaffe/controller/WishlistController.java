package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.model.Wishlist;
import com.progetto.ecomcaffe.model.Prodotto;
import com.progetto.ecomcaffe.service.UtenteService;
import com.progetto.ecomcaffe.service.WishlistService;
import com.progetto.ecomcaffe.service.ProdottoService;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {
    private final WishlistService wishlistService;
    private final ProdottoService prodottoService;
    private final UtenteService utenteService;

    @Autowired
    public WishlistController(WishlistService wishlistService, ProdottoService prodottoService, UtenteService utenteService) {
        this.wishlistService = wishlistService;
        this.prodottoService = prodottoService;
        this.utenteService = utenteService;
    }

    // ============================================================
    // Sezione: Visualizzazione della Wishlist
    // ============================================================

    // GET: /wishlist
    // Visualizza la wishlist dell'utente autenticato.
    @GetMapping
    public String mostraWishlist(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        // Recupera l'utente dal database usando il username ottenuto dal contesto di sicurezza
        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }
        Utente utente = utenteOpt.get();
        List<Wishlist> wishlist = wishlistService.getWishlistByUtente(utente);
        model.addAttribute("wishlist", wishlist);
        return "shopping/wishlist";
    }

    // ============================================================
    // Sezione: Gestione Aggiunta di un Prodotto alla Wishlist
    // ============================================================

    // POST: /wishlist/aggiungi/{idProdotto}
    // Aggiunge un prodotto alla wishlist dell'utente utilizzando l'ID del prodotto.
    @PostMapping("/aggiungi/{idProdotto}")
    public String aggiungiAWishlist(@PathVariable Integer idProdotto, HttpSession session) {
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) {
            return "redirect:/login";
        }

        Optional<Prodotto> prodottoOpt = prodottoService.getProdottoById(idProdotto);
        if (prodottoOpt.isPresent()) {
            wishlistService.addToWishlist(utente, prodottoOpt.get());
        } else {
            System.out.println("Prodotto con ID " + idProdotto + " non trovato!");
        }

        return "redirect:/wishlist";
    }

    // ============================================================
    // Sezione: Gestione Rimozione di un Prodotto dalla Wishlist
    // ============================================================

    // POST: /wishlist/rimuovi/{idProdotto}
    // Rimuove un prodotto dalla wishlist dell'utente.
    @Transactional
    @PostMapping("/rimuovi/{idProdotto}")
    public String rimuoviDaWishlist(@PathVariable Integer idProdotto, HttpSession session) {
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) {
            return "redirect:/login";
        }

        wishlistService.removeFromWishlist(utente, idProdotto);
        return "redirect:/wishlist";
    }
}
