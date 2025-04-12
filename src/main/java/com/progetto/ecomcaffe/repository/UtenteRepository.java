package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UtenteRepository extends JpaRepository<Utente, Integer> {
    Optional<Utente> findByUsername(String username);
    Optional<Utente> findByEmail(String email);
}

