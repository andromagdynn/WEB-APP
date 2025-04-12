package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.*;
import com.progetto.ecomcaffe.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/carrello")
public class CarrelloController {
    private final CarrelloService carrelloService;
    private final ProdottoService prodottoService;
    private final UtenteService utenteService;
    private final OrdineService ordineService;
    private final DettagliOrdineService dettagliOrdineService;
    private final CouponService couponService;
    private final TrackingOrdineService trackingOrdineService;

    @Autowired
    public CarrelloController(CarrelloService carrelloService,
                              ProdottoService prodottoService,
                              UtenteService utenteService,
                              OrdineService ordineService,
                              DettagliOrdineService dettagliOrdineService,
                              CouponService couponService,
                              TrackingOrdineService trackingOrdineService) { // Aggiunto qui
        this.carrelloService = carrelloService;
        this.prodottoService = prodottoService;
        this.utenteService = utenteService;
        this.ordineService = ordineService;
        this.dettagliOrdineService = dettagliOrdineService;
        this.couponService = couponService;
        this.trackingOrdineService = trackingOrdineService; // Aggiunto qui
    }

    // ============================================================
    // Sezione: Visualizzazione del Carrello
    // ============================================================

    // GET: /carrello
    // Visualizza il carrello dell'utente autenticato, calcolando il totale e applicando eventuali coupon.
    @GetMapping("")
    public String visualizzaCarrello(@AuthenticationPrincipal UserDetails userDetails, Model model, HttpSession session) {
        if (userDetails == null) {
            return "redirect:/login";
        }

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }

        Utente utente = utenteOpt.get();
        List<Carrello> cartItems = carrelloService.getCarrelloByUtente(utente);
        BigDecimal totale = cartItems.stream()
                .map(item -> item.getProdotto().getPrezzo().multiply(BigDecimal.valueOf(item.getQuantita())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Recupera il coupon dalla sessione
        String couponCode = (String) session.getAttribute("couponCode");
        BigDecimal scontoPercentuale = BigDecimal.ZERO;

        if (couponCode != null) {
            Coupon coupon = couponService.getCouponByCode(couponCode);
            if (coupon != null && couponService.isCouponValid(coupon)) {
                scontoPercentuale = coupon.getSconto();
                totale = couponService.calcolaSconto(totale, coupon);
                model.addAttribute("couponCode", coupon.getCodice());
                model.addAttribute("scontoPercentuale", scontoPercentuale);
            } else {
                session.removeAttribute("couponCode"); // Rimuove il coupon non valido
            }
        }

        totale = totale.setScale(2, BigDecimal.ROUND_HALF_UP);

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totale", totale);
        model.addAttribute("scontoPercentuale", scontoPercentuale);

        return "shopping/carrello";
    }

    // ============================================================
    // Sezione: Gestione Prodotti nel Carrello
    // ============================================================

    // POST: /carrello/aggiungi/{idProdotto}
    // Aggiunge un prodotto al carrello dell'utente autenticato.
    @PostMapping("/aggiungi/{idProdotto}")
    public String aggiungiAlCarrello(@PathVariable Integer idProdotto,
                                     @RequestParam int quantita,
                                     @AuthenticationPrincipal UserDetails userDetails,
                                     Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }
        Utente utente = utenteOpt.get();

        if (quantita <= 0) {
            model.addAttribute("error", "La quantità deve essere maggiore di zero.");
            return "redirect:/carrello";
        }
        Optional<Prodotto> prodottoOpt = prodottoService.getProdottoById(idProdotto);
        if (!prodottoOpt.isPresent()) {
            model.addAttribute("error", "Prodotto non trovato.");
            return "redirect:/carrello";
        }
        Prodotto prodotto = prodottoOpt.get();
        if (quantita > prodotto.getDisponibilita()) {
            model.addAttribute("error", "La quantità richiesta supera la disponibilità in magazzino.");
            return "redirect:/carrello";
        }
        carrelloService.aggiungiAlCarrello(utente, prodotto, quantita);
        return "redirect:/carrello";
    }

    // POST: /carrello/aggiorna/{idProdotto}
    // Aggiorna la quantità di un prodotto nel carrello dell'utente autenticato.
    @PostMapping("/aggiorna/{idProdotto}")
    public String aggiornaQuantita(@PathVariable Integer idProdotto,
                                   @RequestParam int nuovaQuantita,
                                   @AuthenticationPrincipal UserDetails userDetails,
                                   Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }
        Utente utente = utenteOpt.get();
        Optional<Prodotto> prodottoOpt = prodottoService.getProdottoById(idProdotto);
        if (!prodottoOpt.isPresent()) {
            model.addAttribute("error", "Prodotto non trovato.");
            return "redirect:/carrello";
        }
        Prodotto prodotto = prodottoOpt.get();

        if (nuovaQuantita < 0) {
            model.addAttribute("error", "La quantità non può essere negativa.");
            return "redirect:/carrello";
        } else if (nuovaQuantita == 0) {
            // Se la quantità è 0, rimuove il prodotto dal carrello
            carrelloService.rimuoviDalCarrello(utente, idProdotto);
        } else if (nuovaQuantita > prodotto.getDisponibilita()) {
            model.addAttribute("error", "La quantità richiesta supera la disponibilità in magazzino.");
            return "redirect:/carrello";
        } else {
            carrelloService.aggiornaQuantitaCarrello(utente, idProdotto, nuovaQuantita);
        }
        return "redirect:/carrello";
    }

    // POST: /carrello/rimuovi/{idProdotto}
    // Rimuove un prodotto dal carrello dell'utente autenticato.
    @PostMapping("/rimuovi/{idProdotto}")
    public String rimuoviDalCarrello(@PathVariable Integer idProdotto,
                                     @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            return "redirect:/login";
        }
        Utente utente = utenteOpt.get();
        carrelloService.rimuoviDalCarrello(utente, idProdotto);
        return "redirect:/carrello";
    }

    // ============================================================
    // Sezione: Checkout e Storico Ordini
    // ============================================================

    // POST: /carrello/acquista
    // Processa l'acquisto, crea l'ordine, aggiorna le disponibilità, crea i dettagli dell'ordine e tracking.
    @PostMapping("/acquista")
    public String processaAcquisto(@AuthenticationPrincipal UserDetails userDetails,
                                   @RequestParam String indirizzo,
                                   @RequestParam(required = false) String couponCode,
                                   Model model,
                                   HttpSession session) {  // Aggiunto HttpSession
        if (userDetails == null) return "redirect:/login";

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) return "redirect:/login";

        Utente utente = utenteOpt.get();
        List<Carrello> cartItems = carrelloService.getCarrelloByUtente(utente);
        if (cartItems.isEmpty()) {
            model.addAttribute("error", "Il carrello è vuoto.");
            return "redirect:/carrello";
        }

        // Calcola il totale
        BigDecimal totale = cartItems.stream()
                .map(item -> item.getProdotto().getPrezzo().multiply(BigDecimal.valueOf(item.getQuantita())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Recupera il coupon dalla sessione
        String sessionCouponCode = (String) session.getAttribute("couponCode");
        if (sessionCouponCode != null) {
            Coupon coupon = couponService.getCouponByCode(sessionCouponCode);
            if (coupon != null && couponService.isCouponValid(coupon)) {
                totale = couponService.calcolaSconto(totale, coupon);
                couponService.applyCoupon(coupon, utente);
            }
        }

        // Creazione dell'ordine
        Ordine ordine = new Ordine();
        ordine.setUtente(utente);
        ordine.setTotale(totale);
        ordine.setIndirizzo(indirizzo);
        ordine.setStato(Ordine.StatoOrdine.IN_ATTESA);
        ordine.setDataOrdine(new Date());
        ordine = ordineService.createOrdine(ordine);

        // Creazione dei dettagli dell'ordine e aggiornamento prodotti
        for (Carrello item : cartItems) {
            Prodotto prodotto = item.getProdotto();
            prodotto.setDisponibilita(prodotto.getDisponibilita() - item.getQuantita());
            prodottoService.updateProdotto(prodotto);

            DettagliOrdine dettaglio = new DettagliOrdine();
            dettaglio.setOrdine(ordine);
            dettaglio.setProdotto(prodotto);
            dettaglio.setQuantita(item.getQuantita());
            dettaglio.setPrezzo(prodotto.getPrezzo());
            dettagliOrdineService.createDettagliOrdine(dettaglio);
        }

        // Creazione del tracking ordine
        TrackingOrdine tracking = new TrackingOrdine();
        tracking.setOrdine(ordine);
        tracking.setStato(TrackingOrdine.StatoTracking.PRESO_IN_CARICO);
        tracking.setData(new java.sql.Timestamp(new Date().getTime()));
        trackingOrdineService.createTracking(tracking);

        // Svuota il carrello dopo l'acquisto
        carrelloService.svuotaCarrello(utente);

        // Rimuove il coupon dalla sessione dopo l'acquisto
        session.removeAttribute("couponCode");

        return "redirect:/carrello/storico";
    }

    // GET: /carrello/storico
    // Visualizza lo storico degli ordini dell'utente autenticato.
    @GetMapping("/storico")
    public String storicoOrdini(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) return "redirect:/login";

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) return "redirect:/login";

        Utente utente = utenteOpt.get();
        List<Ordine> ordini = ordineService.getOrdiniByUtente(utente);

        model.addAttribute("ordini", ordini);
        return "shopping/storico";
    }

    // GET: /carrello/dettagli/{ordineId}
    // Visualizza i dettagli di un ordine (pagina view).
    @GetMapping("/dettagli/{ordineId}")
    public String dettagliOrdine(@PathVariable Integer ordineId, @AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }

        Optional<Ordine> ordineOpt = ordineService.getOrdineById(ordineId);
        if (!ordineOpt.isPresent()) {
            return "redirect:/storico";
        }

        Ordine ordine = ordineOpt.get();
        List<DettagliOrdine> dettagli = dettagliOrdineService.getDettagliOrdineByOrdineId(ordineId);

        model.addAttribute("ordine", ordine);
        model.addAttribute("dettagli", dettagli);
        return "ordine/dettagli"; // Vista JSP per i dettagli dell'ordine
    }

    // ============================================================
    // Sezione: Calcolo Totale e Gestione Coupon
    // ============================================================

    // GET: /carrello/calcolaTotale
    // Calcola il totale del carrello applicando eventualmente il coupon e restituisce i dati in formato JSON.
    @GetMapping("/calcolaTotale")
    @ResponseBody
    public Map<String, String> calcolaTotale(@AuthenticationPrincipal UserDetails userDetails,
                                             @RequestParam(required = false) String couponCode,
                                             HttpSession session) {
        Map<String, String> response = new HashMap<>();

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) {
            response.put("totale", "0.00");
            response.put("couponCode", "N/A");
            response.put("scontoPercentuale", "0");
            return response;
        }

        Utente utente = utenteOpt.get();
        List<Carrello> cartItems = carrelloService.getCarrelloByUtente(utente);
        BigDecimal totale = cartItems.stream()
                .map(item -> item.getProdotto().getPrezzo().multiply(BigDecimal.valueOf(item.getQuantita())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        String codiceCoupon = "Nessuno";
        BigDecimal scontoPercentuale = BigDecimal.ZERO;

        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Coupon coupon = couponService.getCouponByCode(couponCode);
            if (coupon != null && couponService.isCouponValid(coupon)) {
                codiceCoupon = coupon.getCodice();
                scontoPercentuale = coupon.getSconto();
                totale = couponService.calcolaSconto(totale, coupon);

                // Salva il coupon nella sessione
                session.setAttribute("couponCode", couponCode);
            }
        }


        totale = totale.setScale(2, BigDecimal.ROUND_HALF_UP);

        response.put("totale", totale.toString()); // Totale con 2 decimali
        response.put("couponCode", codiceCoupon);
        response.put("scontoPercentuale", scontoPercentuale.toString());

        return response;
    }

    // POST: /carrello/rimuoviCoupon/{couponId}
    // Rimuove un coupon specifico tramite il suo ID.
    @PostMapping("/rimuoviCoupon/{couponId}")
    public String rimuoviCoupon(@PathVariable Integer couponId, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) return "redirect:/login";

        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(userDetails.getUsername());
        if (!utenteOpt.isPresent()) return "redirect:/login";

        Optional<Coupon> couponOpt = couponService.getCouponById(couponId); // Usa il metodo corretto
        if (couponOpt.isPresent()) {
            couponService.rimuoviCoupon(couponOpt.get());
        }

        return "redirect:/carrello";
    }

    // POST: /carrello/rimuovi-coupon
    // Rimuove il coupon dalla sessione.
    @PostMapping("/rimuovi-coupon")
    public String rimuoviCoupon(HttpSession session) {
        session.removeAttribute("couponCode");
        return "redirect:/carrello"; // Dopo la rimozione, aggiorna la pagina
    }

    // ============================================================
    // Sezione: Dettagli Ordine in JSON
    // ============================================================
    // GET: /carrello/ordine/dettagli/{ordineId}
    // Restituisce i dettagli dell'ordine in formato JSON.
    @GetMapping("/ordine/dettagli/{ordineId}")
    @ResponseBody
    public List<Map<String, Object>> getDettagliOrdine(@PathVariable Integer ordineId, @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return Collections.emptyList(); // Se non autenticato, restituisce lista vuota
        }

        Optional<Ordine> ordineOpt = ordineService.getOrdineById(ordineId);
        if (!ordineOpt.isPresent()) {
            return Collections.emptyList();
        }

        List<DettagliOrdine> dettagli = dettagliOrdineService.getDettagliOrdineByOrdineId(ordineId);
        List<Map<String, Object>> response = new ArrayList<>();

        for (DettagliOrdine dettaglio : dettagli) {
            Map<String, Object> dettagliMap = new HashMap<>();
            dettagliMap.put("prodottoNome", dettaglio.getProdotto().getNome());
            dettagliMap.put("quantita", dettaglio.getQuantita());
            dettagliMap.put("prezzo", dettaglio.getPrezzo());
            dettagliMap.put("subtotale", dettaglio.getPrezzo().multiply(BigDecimal.valueOf(dettaglio.getQuantita())));
            response.add(dettagliMap);
        }

        return response;
    }
}
