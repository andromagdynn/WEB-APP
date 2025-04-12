package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.repository.UtenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@Service
public class UtenteService {

    private final UtenteRepository utenteRepository;
    private static final Logger LOGGER = Logger.getLogger(UtenteService.class.getName());

    @Autowired
    public UtenteService(UtenteRepository utenteRepository) {
        this.utenteRepository = utenteRepository;
    }

    // Recupera un utente per ID
    public Optional<Utente> getUtenteById(int id) {
        return utenteRepository.findById(id);
    }

    // Recupera un utente per username
    public Optional<Utente> getUtenteByUsername(String username) {
        return utenteRepository.findByUsername(username);
    }

    // Recupera un utente per email
    public Optional<Utente> getUtenteByEmail(String email) {
        return utenteRepository.findByEmail(email);
    }

    // Recupera tutti gli utenti
    public List<Utente> getAllUsers() {
        return utenteRepository.findAll();
    }

    // Salva un nuovo utente e registra il processo
    @Transactional
    public Utente createUtente(Utente utente) {
        LOGGER.info("Tentativo di salvataggio utente: " + utente.getUsername());
        Utente savedUser = utenteRepository.save(utente);
        LOGGER.info("Utente salvato con successo: " + savedUser.getUsername() + " (ID: " + savedUser.getId() + ")");
        return savedUser;
    }
}
