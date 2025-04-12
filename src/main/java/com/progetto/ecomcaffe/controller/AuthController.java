package com.progetto.ecomcaffe.controller;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.service.UtenteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;
import java.util.logging.Logger;

@Controller
@RequestMapping
public class AuthController {
    private final UtenteService utenteService;
    private final PasswordEncoder passwordEncoder;
    private static final Logger LOGGER = Logger.getLogger(AuthController.class.getName());

    @Autowired
    public AuthController(UtenteService utenteService, PasswordEncoder passwordEncoder) {
        this.utenteService = utenteService;
        this.passwordEncoder = passwordEncoder;
    }

    // ============================================================
    // Sezione: Pagine di Login e Registrazione
    // ============================================================

    // GET: /login
    // Restituisce la pagina di login.
    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    // GET: /registrati
    // Restituisce la pagina di registrazione.
    @GetMapping("/registrati")
    public String register() {
        return "auth/registrazione";
    }

    // ============================================================
    // Sezione: Gestione Registrazione Utente
    // ============================================================

    // POST: /registrati
    // Gestisce la registrazione di un nuovo utente.
    @PostMapping("/registrati")
    public String registerUser(@RequestParam String username,
                               @RequestParam String email,
                               @RequestParam String password,
                               Model model) {
        LOGGER.info("Tentativo di registrazione per: " + username + " - " + email);

        // Verifica se username/email esistono già
        Optional<Utente> existingUser = utenteService.getUtenteByUsername(username);
        Optional<Utente> existingEmail = utenteService.getUtenteByEmail(email);

        if (existingUser.isPresent()) {
            LOGGER.warning("Username già in uso: " + username);
            model.addAttribute("error", "Username già in uso!");
            return "auth/registrazione";
        }

        if (existingEmail.isPresent()) {
            LOGGER.warning("Email già registrata: " + email);
            model.addAttribute("error", "Email già registrata!");
            return "auth/registrazione";
        }

        // Creazione nuovo utente
        Utente nuovoUtente = new Utente();
        nuovoUtente.setUsername(username);
        nuovoUtente.setEmail(email);
        nuovoUtente.setPassword(passwordEncoder.encode(password)); // Hash della password
        nuovoUtente.setRuolo(Utente.Ruolo.REGISTRATO);
        nuovoUtente.setStato(Utente.Stato.ATTIVO);

        // Salvataggio utente
        try {
            Utente savedUser = utenteService.createUtente(nuovoUtente);
            LOGGER.info("Utente registrato con successo: " + savedUser.getUsername() + " (ID: " + savedUser.getId() + ")");
        } catch (Exception e) {
            LOGGER.severe("Errore nel salvataggio dell'utente: " + e.getMessage());
            model.addAttribute("error", "Errore durante la registrazione!");
            return "auth/registrazione";
        }

        LOGGER.info("Reindirizzamento al login dopo registrazione");
        return "redirect:/login";
    }

    // ============================================================
    // Sezione: Gestione Login e Sessione Utente
    // ============================================================

    // POST: /doLogin
    // Dopo il login, salva l'utente nella sessione.
    @PostMapping("/doLogin")
    public String doLogin(@RequestParam String username, HttpSession session) {
        Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(username);
        if (utenteOpt.isPresent()) {
            Utente utente = utenteOpt.get();
            session.setAttribute("utente", utente);
            LOGGER.info("Utente autenticato e salvato nella sessione: " + utente.getUsername());
            return "redirect:/";
        } else {
            LOGGER.warning("Errore nel login: utente non trovato");
            return "redirect:/login?error";
        }
    }

    // ============================================================
    // Sezione: Logout
    // ============================================================

    // GET: /logout
    // Invalida la sessione e reindirizza alla home.
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}