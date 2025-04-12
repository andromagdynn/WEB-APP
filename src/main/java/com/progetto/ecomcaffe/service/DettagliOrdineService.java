package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.DettagliOrdine;
import com.progetto.ecomcaffe.repository.DettagliOrdineRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DettagliOrdineService {

    private final DettagliOrdineRepository dettagliOrdineRepository;

    @Autowired
    public DettagliOrdineService(DettagliOrdineRepository dettagliOrdineRepository) {
        this.dettagliOrdineRepository = dettagliOrdineRepository;
    }

    // Recupera i dettagli di un ordine tramite l'ID dell'ordine.
    public List<DettagliOrdine> getDettagliOrdineByOrdineId(int ordineId) {
        return dettagliOrdineRepository.findByOrdineId(ordineId);
    }

    // Crea un nuovo record di dettagli ordine.
    public DettagliOrdine createDettagliOrdine(DettagliOrdine dettagliOrdine) {
        return dettagliOrdineRepository.save(dettagliOrdine);
    }

    // Aggiorna un record esistente di dettagli ordine.
    public DettagliOrdine updateDettagliOrdine(DettagliOrdine dettagliOrdine) {
        return dettagliOrdineRepository.save(dettagliOrdine);
    }

    // Elimina i dettagli dell'ordine identificati dall'ID.
    public void deleteDettagliOrdine(int id) {
        dettagliOrdineRepository.deleteById(id);
    }
}