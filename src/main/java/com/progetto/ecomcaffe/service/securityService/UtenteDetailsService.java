package com.progetto.ecomcaffe.service.securityService;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.repository.UtenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class UtenteDetailsService implements UserDetailsService {

    // Repository per accedere ai dati degli utenti.
    private final UtenteRepository utenteRepository;

    @Autowired
    public UtenteDetailsService(UtenteRepository utenteRepository) {
        this.utenteRepository = utenteRepository;
    }

    // Carica i dettagli dell'utente in base al nome utente.
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Utente utente = utenteRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Utente non trovato"));
        return new User(
                utente.getUsername(),
                utente.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + utente.getRuolo().name()))
        );
    }
}