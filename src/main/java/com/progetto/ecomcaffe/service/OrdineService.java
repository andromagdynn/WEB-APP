package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Ordine;
import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.repository.OrdineRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OrdineService {

    private final OrdineRepository ordineRepository;

    @Autowired
    public OrdineService(OrdineRepository ordineRepository) {
        this.ordineRepository = ordineRepository;
    }

    // Crea un nuovo ordine.
    public Ordine createOrdine(Ordine ordine) {
        return ordineRepository.save(ordine);
    }

    // Aggiorna un ordine esistente.
    public void updateOrdine(Ordine ordine) {
        ordineRepository.save(ordine);
    }

    // Elimina un ordine per ID.
    public void deleteOrdine(int id) {
        ordineRepository.deleteById(id);
    }

    // Recupera gli ordini relativi a un utente.
    public List<Ordine> getOrdiniByUtente(Utente utente) {
        return ordineRepository.findByUtente(utente);
    }

    // Recupera un ordine tramite il suo ID.
    public Optional<Ordine> getOrdineById(int id) {
        return ordineRepository.findById(id);
    }
}