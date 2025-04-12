package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Wishlist;
import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.model.Prodotto;
import com.progetto.ecomcaffe.repository.WishlistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class WishlistService {

    private final WishlistRepository wishlistRepository;

    @Autowired
    public WishlistService(WishlistRepository wishlistRepository) {
        this.wishlistRepository = wishlistRepository;
    }

    // Recupera la wishlist per un utente.
    public List<Wishlist> getWishlistByUtente(Utente utente) {
        return wishlistRepository.findByUtente(utente);
    }

    // Aggiunge un prodotto alla wishlist se non è già presente.
    public void addToWishlist(Utente utente, Prodotto prodotto) {
        Optional<Wishlist> esiste = wishlistRepository.findByUtenteAndProdottoId(utente, prodotto.getId());
        if (esiste.isEmpty()) {
            Wishlist wishlist = new Wishlist();
            wishlist.setUtente(utente);
            wishlist.setProdotto(prodotto);
            wishlistRepository.save(wishlist);
        }
    }

    // Rimuove un prodotto dalla wishlist.
    public void removeFromWishlist(Utente utente, Integer prodottoId) {
        wishlistRepository.deleteByUtenteAndProdottoId(utente, prodottoId);
    }
}