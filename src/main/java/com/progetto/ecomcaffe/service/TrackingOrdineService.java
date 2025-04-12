package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.TrackingOrdine;
import com.progetto.ecomcaffe.repository.TrackingOrdineRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TrackingOrdineService {

    // Repository per il tracking degli ordini.
    private final TrackingOrdineRepository trackingOrdineRepository;

    @Autowired
    public TrackingOrdineService(TrackingOrdineRepository trackingOrdineRepository) {
        this.trackingOrdineRepository = trackingOrdineRepository;
    }

    // Salva un nuovo record di tracking ordine.
    public TrackingOrdine createTracking(TrackingOrdine trackingOrdine) {
        return trackingOrdineRepository.save(trackingOrdine);
    }

    // Elimina un record di tracking ordine tramite ID.
    public void deleteTracking(int id) {
        trackingOrdineRepository.deleteById(id);
    }
}
