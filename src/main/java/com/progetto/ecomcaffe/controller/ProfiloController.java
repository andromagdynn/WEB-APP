package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.model.Ordine;
import com.progetto.ecomcaffe.service.UtenteService;
import com.progetto.ecomcaffe.service.OrdineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class ProfiloController {
    private final UtenteService utenteService;
    private final OrdineService ordineService;

    @Autowired
    public ProfiloController(UtenteService utenteService, OrdineService ordineService) {
        this.utenteService = utenteService;
        this.ordineService = ordineService;
    }

    // ============================================================
    // Sezione: Visualizzazione Profilo Utente
    // ============================================================

    // GET: /profilo
    // Recupera il profilo dell'utente autenticato, includendo statistiche e storico ordini.
    @GetMapping("/profilo")
    public String profilo(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }

        Utente utente = utenteOpt.get();
        List<Ordine> ordini = ordineService.getOrdiniByUtente(utente);

        // Conta il numero di ordini e calcola la spesa totale
        int numeroOrdini = ordini.size();
        BigDecimal spesaTotale = ordini.stream()
                .map(Ordine::getTotale)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Recupera indirizzi di spedizione unici
        Set<String> indirizziUnici = new HashSet<>();
        for (Ordine ordine : ordini) {
            if (ordine.getIndirizzo() != null && !ordine.getIndirizzo().isEmpty()) {
                indirizziUnici.add(ordine.getIndirizzo());
            }
        }

        // Statistiche: Mostra SOLO gli ultimi 6 mesi
        List<String> dateOrdini = new ArrayList<>();
        List<BigDecimal> importiOrdini = new ArrayList<>();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");

        Calendar seiMesiFa = Calendar.getInstance();
        seiMesiFa.add(Calendar.MONTH, -6); // Considera solo gli ordini degli ultimi 6 mesi

        for (Ordine ordine : ordini) {
            if (ordine.getDataOrdine().after(seiMesiFa.getTime())) {
                dateOrdini.add(formatter.format(ordine.getDataOrdine())); // Mese-anno
                importiOrdini.add(ordine.getTotale());
            }
        }

        model.addAttribute("utente", utente);
        model.addAttribute("numeroOrdini", numeroOrdini);
        model.addAttribute("spesaTotale", spesaTotale);
        model.addAttribute("indirizziUsati", indirizziUnici);
        model.addAttribute("dateOrdini", dateOrdini);
        model.addAttribute("importiOrdini", importiOrdini);

        return "utente/profilo";
    }
}
