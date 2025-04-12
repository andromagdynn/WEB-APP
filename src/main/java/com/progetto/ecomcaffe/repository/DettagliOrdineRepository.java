package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.DettagliOrdine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DettagliOrdineRepository extends JpaRepository<DettagliOrdine, Integer> {
    List<DettagliOrdine> findByOrdineId(int ordineId);
}
