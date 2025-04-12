package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.*;
import com.progetto.ecomcaffe.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final UtenteService utenteService;
    private final OrdineService ordineService;
    private final DettagliOrdineService dettagliOrdineService;
    private final ProdottoService prodottoService;
    private final CategoriaService categoriaService;
    private final BrandService brandService;
    private final CouponService couponService;

    @Autowired
    public AdminController(UtenteService utenteService,
                           OrdineService ordineService,
                           DettagliOrdineService dettagliOrdineService,
                           ProdottoService prodottoService,
                           CategoriaService categoriaService,
                           BrandService brandService,
                           CouponService couponService) {
        this.utenteService = utenteService;
        this.ordineService = ordineService;
        this.dettagliOrdineService = dettagliOrdineService;
        this.prodottoService = prodottoService;
        this.categoriaService = categoriaService;
        this.brandService = brandService;
        this.couponService = couponService;
    }

    // ============================================================
    // Sezione: Home Amministrazione
    // ============================================================
    // GET: /admin
    // Restituisce la pagina principale dell'area admin.
    @GetMapping("")
    public String adminHome() {
        return "admin/index";
    }

    // ============================================================
    // Sezione: Gestione Utenti e Ordini
    // ============================================================

    // GET: /admin/utenti
    // Recupera e visualizza la lista degli utenti insieme ai dettagli degli ordini.
    @GetMapping("/utenti")
    public String listUsers(Model model) {
        List<Utente> utenti = utenteService.getAllUsers();
        Map<Integer, Long> ordiniCount = new HashMap<>();
        Map<Integer, List<Ordine>> ordiniDettagli = new HashMap<>();

        for (Utente utente : utenti) {
            List<Ordine> ordini = ordineService.getOrdiniByUtente(utente);
            ordiniCount.put(utente.getId(), (long) ordini.size());
            ordiniDettagli.put(utente.getId(), ordini);
        }

        // Aggiunge gli attributi al model per la view
        model.addAttribute("utenti", utenti);
        model.addAttribute("ordiniCount", ordiniCount);
        model.addAttribute("ordiniDettagli", ordiniDettagli);

        return "admin/utenti";
    }

    // GET: /admin/utente/{id}/ordini
    // Restituisce in formato JSON la lista degli ordini per un utente specifico.
    @GetMapping("/utente/{id}/ordini")
    @ResponseBody
    public List<Map<String, Object>> getOrdiniUtente(@PathVariable("id") Integer id) {
        Optional<Utente> utenteOpt = utenteService.getUtenteById(id);
        if (!utenteOpt.isPresent()) {
            return Collections.emptyList();
        }
        List<Ordine> ordini = ordineService.getOrdiniByUtente(utenteOpt.get());
        List<Map<String, Object>> response = new ArrayList<>();

        // Ciclo per preparare la risposta con i dati essenziali degli ordini
        for (Ordine ordine : ordini) {
            Map<String, Object> ordineMap = new HashMap<>();
            ordineMap.put("id", ordine.getId());
            ordineMap.put("totale", ordine.getTotale());
            ordineMap.put("stato", ordine.getStato().toString());
            response.add(ordineMap);
        }
        return response;
    }

    // GET: /admin/ordine/dettagli/{ordineId}
    // Restituisce in formato JSON i dettagli di un ordine specifico.
    @GetMapping("/ordine/dettagli/{ordineId}")
    @ResponseBody
    public List<Map<String, Object>> getDettagliOrdine(@PathVariable Integer ordineId) {
        Optional<Ordine> ordineOpt = ordineService.getOrdineById(ordineId);
        if (!ordineOpt.isPresent()) {
            return Collections.emptyList();
        }

        List<DettagliOrdine> dettagli = dettagliOrdineService.getDettagliOrdineByOrdineId(ordineId);
        List<Map<String, Object>> response = new ArrayList<>();
        // Ciclo per assemblare i dettagli dell'ordine, incluso il calcolo del subtotale.
        for (DettagliOrdine dettaglio : dettagli) {
            Map<String, Object> dettagliMap = new HashMap<>();
            dettagliMap.put("prodottoNome", dettaglio.getProdotto().getNome());
            dettagliMap.put("quantita", dettaglio.getQuantita());
            dettagliMap.put("prezzo", dettaglio.getPrezzo());
            dettagliMap.put("subtotale", dettaglio.getPrezzo().multiply(new BigDecimal(dettaglio.getQuantita())));
            response.add(dettagliMap);
        }
        return response;
    }

    // POST: /admin/ordine/updateStatus
    // Aggiorna lo stato della spedizione di un ordine.
    @PostMapping("/ordine/updateStatus")
    @ResponseBody
    public String updateOrderStatus(@RequestParam("ordineId") Integer ordineId,
                                    @RequestParam("statoSpedizione") String statoSpedizione) {
        Optional<Ordine> ordineOpt = ordineService.getOrdineById(ordineId);
        if (!ordineOpt.isPresent()) {
            return "error: ordine non trovato";
        }
        Ordine ordine = ordineOpt.get();
        try {
            // Converte la stringa dello stato in un valore enumerato e aggiorna l'ordine
            Ordine.StatoOrdine newState = Ordine.StatoOrdine.valueOf(statoSpedizione);
            ordine.setStato(newState);
            ordineService.updateOrdine(ordine);
            return "success";
        } catch (IllegalArgumentException ex) {
            return "error: stato non valido";
        }
    }

    // POST: /admin/utente/toggleRole
    // Cambia il ruolo dell'utente tra REGISTRATO e ADMIN.
    @PostMapping("/utente/toggleRole")
    @ResponseBody
    public String toggleRole(@RequestParam("utenteId") Integer utenteId) {
        Optional<Utente> utenteOpt = utenteService.getUtenteById(utenteId);
        if (!utenteOpt.isPresent()) {
            return "Errore: utente non trovato";
        }
        Utente utente = utenteOpt.get();
        if (utente.getRuolo() == Utente.Ruolo.REGISTRATO) {
            utente.setRuolo(Utente.Ruolo.ADMIN);
        } else {
            utente.setRuolo(Utente.Ruolo.REGISTRATO);
        }
        utenteService.createUtente(utente);
        return "Ruolo aggiornato correttamente! (" + utente.getUsername() + " -> " + utente.getRuolo() + ")";
    }

    // =============================================
    // Sezione: Gestione Prodotti, Categorie e Brand
    // =============================================

    // GET: /admin/gestione
    // Visualizza la pagina di gestione con prodotti, categorie e brand.
    @GetMapping("/gestione")
    public String gestionePage(Model model) {
        model.addAttribute("prodotti", prodottoService.getProdottiFiltrati(null, null, null));
        model.addAttribute("categorie", categoriaService.getAllCategorie());
        model.addAttribute("brand", brandService.getAllBrands());
        return "admin/gestione"; // corrisponde a /WEB-INF/views/admin/gestione.jsp
    }

    // POST: /admin/prodotto/update
    // Aggiorna un prodotto esistente verificando il prezzo e il flag inVetrina.
    @PostMapping("/prodotto/update")
    @ResponseBody
    public Map<String, Object> updateProdotto(@ModelAttribute Prodotto prodotto) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Verifica che il prezzo non sia negativo
            if (prodotto.getPrezzo() != null && prodotto.getPrezzo().compareTo(BigDecimal.ZERO) < 0) {
                response.put("status", "error");
                response.put("message", "Il prezzo non può essere negativo.");
                return response;
            }
            // Se il flag inVetrina è null, viene impostato a false
            if (prodotto.getInVetrina() == null) {
                prodotto.setInVetrina(false);
            }
            Prodotto updated = prodottoService.updateProdotto(prodotto);
            response.put("status", "success");
            response.put("message", "Prodotto aggiornato correttamente!");
            response.put("prodotto", updated);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante l'aggiornamento: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/prodotto/block
    // Blocca un prodotto impostando la disponibilità a 0.
    @PostMapping("/prodotto/block")
    @ResponseBody
    public Map<String, Object> blockProdotto(@RequestParam("id") Integer id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<Prodotto> prodOpt = prodottoService.getProdottoById(id);
            if(prodOpt.isPresent()){
                Prodotto prodotto = prodOpt.get();
                // Blocco del prodotto: disponibilità impostata a 0
                prodotto.setDisponibilita(0);
                prodottoService.updateProdotto(prodotto);
                response.put("status", "success");
                response.put("message", "Prodotto bloccato correttamente.");
            } else {
                response.put("status", "error");
                response.put("message", "Prodotto non trovato.");
            }
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante il blocco: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/prodotto/aggiungi
    // Aggiunge un nuovo prodotto, con verifica del prezzo negativo e del flag inVetrina.
    @PostMapping("/prodotto/aggiungi")
    @ResponseBody
    public Map<String, Object> aggiungiProdotto(@ModelAttribute Prodotto prodotto) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Verifica che il prezzo non sia negativo
            if (prodotto.getPrezzo() != null && prodotto.getPrezzo().compareTo(BigDecimal.ZERO) < 0) {
                response.put("status", "error");
                response.put("message", "Il prezzo non può essere negativo.");
                return response;
            }
            // Se il flag inVetrina è null, viene impostato a false
            if (prodotto.getInVetrina() == null) {
                prodotto.setInVetrina(false);
            }
            Prodotto nuovo = prodottoService.updateProdotto(prodotto);
            response.put("status", "success");
            response.put("message", "Prodotto aggiunto correttamente!");
            response.put("prodotto", nuovo);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante l'aggiunta del prodotto: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/categoria/update
    // Aggiorna una categoria esistente.
    @PostMapping("/categoria/update")
    @ResponseBody
    public Map<String, Object> updateCategoria(@ModelAttribute Categoria categoria) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categoria updated = categoriaService.updateCategoria(categoria);
            response.put("status", "success");
            response.put("message", "Categoria aggiornata.");
            response.put("categoria", updated);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore aggiornamento categoria: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/categoria/delete
    // Elimina una categoria specifica.
    @PostMapping("/categoria/delete")
    @ResponseBody
    public Map<String, Object> deleteCategoria(@RequestParam("id") Integer id) {
        Map<String, Object> response = new HashMap<>();
        try {
            categoriaService.deleteCategoria(id);
            response.put("status", "success");
            response.put("message", "Categoria eliminata.");
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore eliminazione categoria: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/brand/update
    // Aggiorna un brand esistente.
    @PostMapping("/brand/update")
    @ResponseBody
    public Map<String, Object> updateBrand(@ModelAttribute Brand brand) {
        Map<String, Object> response = new HashMap<>();
        try {
            Brand updated = brandService.updateBrand(brand);
            response.put("status", "success");
            response.put("message", "Brand aggiornato.");
            response.put("brand", updated);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore aggiornamento brand: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/brand/delete
    // Elimina un brand specifico.
    @PostMapping("/brand/delete")
    @ResponseBody
    public Map<String, Object> deleteBrand(@RequestParam("id") Integer id) {
        Map<String, Object> response = new HashMap<>();
        try {
            brandService.deleteBrand(id);
            response.put("status", "success");
            response.put("message", "Brand eliminato.");
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore eliminazione brand: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/categoria/aggiungi
    // Aggiunge una nuova categoria tramite il relativo service.
    @PostMapping("/categoria/aggiungi")
    @ResponseBody
    public Map<String, Object> aggiungiCategoria(@ModelAttribute Categoria categoria) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categoria nuova = categoriaService.createCategoria(categoria);
            response.put("status", "success");
            response.put("message", "Categoria aggiunta correttamente!");
            response.put("categoria", nuova);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante l'aggiunta della categoria: " + e.getMessage());
        }
        return response;
    }

    // POST: /admin/brand/aggiungi
    // Aggiunge un nuovo brand tramite il relativo service.
    @PostMapping("/brand/aggiungi")
    @ResponseBody
    public Map<String, Object> aggiungiBrand(@ModelAttribute Brand brand) {
        Map<String, Object> response = new HashMap<>();
        try {
            Brand nuovo = brandService.createBrand(brand);
            response.put("status", "success");
            response.put("message", "Brand aggiunto correttamente!");
            response.put("brand", nuovo);
        } catch(Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante l'aggiunta del brand: " + e.getMessage());
        }
        return response;
    }

    // ========================
    // Sezione: Gestione Coupon
    // ========================

    // GET: /admin/coupon
    // Visualizza la pagina di gestione dei coupon.
    @GetMapping("/coupon")
    public String couponPage(Model model) {
        List<Coupon> coupons = couponService.getAllCoupons();
        model.addAttribute("coupons", coupons);
        return "admin/coupon"; // corrisponde a /WEB-INF/views/admin/coupon.jsp
    }

    // POST: /admin/coupon/aggiungi
    // Aggiunge un nuovo coupon (tramite richiesta Ajax).
    @PostMapping("/coupon/aggiungi")
    @ResponseBody
    public Map<String, Object> aggiungiCoupon(@ModelAttribute Coupon coupon) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Imposta il coupon come non usato all'inserimento
            coupon.setUsato(false);
            Coupon nuovoCoupon = couponService.createCoupon(coupon);
            response.put("status", "success");
            response.put("message", "Coupon aggiunto correttamente!");
            response.put("coupon", nuovoCoupon);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Errore durante l'aggiunta del coupon: " + e.getMessage());
        }
        return response;
    }
}