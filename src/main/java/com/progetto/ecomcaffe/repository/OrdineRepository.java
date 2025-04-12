package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Ordine;
import com.progetto.ecomcaffe.model.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrdineRepository extends JpaRepository<Ordine, Integer> {
    List<Ordine> findByUtente(Utente utente);
    Optional<Ordine> findById(Integer id);
}
