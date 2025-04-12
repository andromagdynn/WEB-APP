package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.TrackingOrdine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrackingOrdineRepository extends JpaRepository<TrackingOrdine, Integer> {
}
