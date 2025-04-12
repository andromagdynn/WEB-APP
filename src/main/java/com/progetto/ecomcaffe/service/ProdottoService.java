package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Prodotto;
import com.progetto.ecomcaffe.repository.ProdottoRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProdottoService {

    private final ProdottoRepository prodottoRepository;

    @Autowired
    public ProdottoService(ProdottoRepository prodottoRepository) {
        this.prodottoRepository = prodottoRepository;
    }

    // Recupera i prodotti filtrati in base a categoria, brand e ricerca.
    public List<Prodotto> getProdottiFiltrati(String categoria, String brand, String ricerca) {
        return prodottoRepository.filtraProdotti(
                        (categoria != null && !categoria.isEmpty()) ? categoria : null,
                        (brand != null && !brand.isEmpty()) ? brand : null,
                        (ricerca != null && !ricerca.isEmpty()) ? ricerca : null
                ).stream()
                // Scarta i prodotti con disponibilita = 0
                .filter(p -> p.getDisponibilita() != null && p.getDisponibilita() > 0)
                .toList();
    }

    // Recupera i prodotti in vetrina.
    public List<Prodotto> getProdottiInVetrina() {
        return prodottoRepository.findByInVetrinaTrue()
                .stream()
                .filter(p -> p.getDisponibilita() > 0)
                .toList();
    }

    // Recupera i 4 prodotti più visti.
    public List<Prodotto> getProdottiPiuVisti() {
        return prodottoRepository.findProdottiPiuVisti()
                .stream()
                .filter(p -> p.getDisponibilita() > 0)
                .limit(4)
                .toList();
    }

    // Incrementa le visualizzazioni di un prodotto.
    @Transactional
    public void incrementaVisualizzazioni(Integer id) {
        if (prodottoRepository.existsById(id)) {
            prodottoRepository.incrementaVisualizzazioni(id);
        } else {
            System.out.println("Errore: Prodotto con ID " + id + " non trovato!");
        }
    }

    // Recupera un prodotto tramite il suo ID.
    public Optional<Prodotto> getProdottoById(Integer id) {
        return prodottoRepository.findById(id);
    }

    // Aggiorna un prodotto.
    public Prodotto updateProdotto(Prodotto prodotto) {
        return prodottoRepository.save(prodotto);
    }
}
