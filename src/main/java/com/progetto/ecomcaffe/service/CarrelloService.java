package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Carrello;
import com.progetto.ecomcaffe.model.Prodotto;
import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.repository.CarrelloRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CarrelloService {

    private final CarrelloRepository carrelloRepository;

    @Autowired
    public CarrelloService(CarrelloRepository carrelloRepository) {
        this.carrelloRepository = carrelloRepository;
    }

    // Restituisce il carrello dell'utente.
    public List<Carrello> getCarrelloByUtente(Utente utente) {
        return carrelloRepository.findByUtente(utente);
    }

    // Aggiunge un prodotto al carrello.
    public void aggiungiAlCarrello(Utente utente, Prodotto prodotto, int quantita) {
        Optional<Carrello> esistente = carrelloRepository.findByUtenteAndProdottoId(utente, prodotto.getId());
        if (esistente.isPresent()) {
            Carrello carrello = esistente.get();
            carrello.setQuantita(carrello.getQuantita() + quantita);
            carrelloRepository.save(carrello);
        } else {
            Carrello nuovo = new Carrello();
            nuovo.setUtente(utente);
            nuovo.setProdotto(prodotto);
            nuovo.setQuantita(quantita);
            carrelloRepository.save(nuovo);
        }
    }

    // Rimuove un prodotto dal carrello.
    @Transactional
    public void rimuoviDalCarrello(Utente utente, Integer prodottoId) {
        carrelloRepository.deleteByUtenteAndProdottoId(utente, prodottoId);
    }

    // Aggiorna la quantità di un prodotto nel carrello.
    @Transactional
    public void aggiornaQuantitaCarrello(Utente utente, Integer prodottoId, int nuovaQuantita) {
        Optional<Carrello> esistente = carrelloRepository.findByUtenteAndProdottoId(utente, prodottoId);
        esistente.ifPresent(carrello -> {
            carrello.setQuantita(nuovaQuantita);
            carrelloRepository.save(carrello);
        });
    }

    // Svuota il carrello dell'utente.
    @Transactional
    public void svuotaCarrello(Utente utente) {
        carrelloRepository.deleteAll(carrelloRepository.findByUtente(utente));
    }
}