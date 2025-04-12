package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Carrello;
import com.progetto.ecomcaffe.model.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CarrelloRepository extends JpaRepository<Carrello, Integer> {
    List<Carrello> findByUtente(Utente utente);
    Optional<Carrello> findByUtenteAndProdottoId(Utente utente, Integer prodottoId);
    void deleteByUtenteAndProdottoId(Utente utente, Integer prodottoId);
}
