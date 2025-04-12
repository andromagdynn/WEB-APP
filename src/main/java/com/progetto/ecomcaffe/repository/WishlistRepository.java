package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Wishlist;
import com.progetto.ecomcaffe.model.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistRepository extends JpaRepository<Wishlist, Integer> {
    List<Wishlist> findByUtente(Utente utente);
    Optional<Wishlist> findByUtenteAndProdottoId(Utente utente, Integer prodottoId);
    void deleteByUtenteAndProdottoId(Utente utente, Integer prodottoId);
}
