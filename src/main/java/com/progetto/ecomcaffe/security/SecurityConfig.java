package com.progetto.ecomcaffe.security;

import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.service.UtenteService;
import com.progetto.ecomcaffe.service.securityService.UtenteDetailsService;
import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Optional;

@Configuration // Indica che questa classe contiene la configurazione per Spring.
public class SecurityConfig {

    // Servizio per gestire gli utenti, utilizzato per recuperare i dettagli dell'utente dal database.
    private final UtenteService utenteService;

    @Autowired // Iniezione automatica del bean UtenteService.
    public SecurityConfig(UtenteService utenteService) {
        this.utenteService = utenteService;
    }

    // Definisce il bean SecurityFilterChain per configurare la sicurezza HTTP.
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // Disabilita la protezione CSRF
                .csrf(csrf -> csrf.disable())

                // Configura le regole di autorizzazione per le richieste HTTP.
                .authorizeHttpRequests(auth -> auth
                        // Consente tutte le richieste di tipo FORWARD.
                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                        // Consente l'accesso pubblico alle pagine principali, API, login e registrazione.
                        .requestMatchers("/", "/api/**", "/login", "/registrati").permitAll()
                        // Richiede il ruolo REGISTRATO o ADMIN per accedere a /profilo, /wishlist e /user.
                        .requestMatchers("/profilo/**", "/wishlist/**", "/user/**").hasAnyRole("REGISTRATO", "ADMIN")
                        // Richiede il ruolo ADMIN per accedere alle pagine amministrative.
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        // Richiede l'autenticazione per tutte le altre richieste.
                        .anyRequest().authenticated()
                )

                // Configura il form di login.
                .formLogin(login -> login
                        // Imposta la pagina di login personalizzata.
                        .loginPage("/login")
                        // Imposta la URL di default a cui reindirizzare dopo un login di successo.
                        .defaultSuccessUrl("/", true)
                        // Consente a tutti l'accesso alla pagina di login.
                        .permitAll()
                        // Definisce un handler per il successo del login.
                        .successHandler((request, response, authentication) -> {
                            // Recupera il nome utente dall'oggetto di autenticazione.
                            String username = authentication.getName();
                            // Usa il servizio per recuperare l'utente dal database.
                            Optional<Utente> utenteOpt = utenteService.getUtenteByUsername(username);
                            if (utenteOpt.isPresent()) {
                                // Imposta l'utente nella sessione HTTP con la chiave "utente".
                                request.getSession().setAttribute("utente", utenteOpt.get());
                            }
                            // Reindirizza l'utente alla home page.
                            response.sendRedirect("/");
                        })
                )

                // Configura il logout.
                .logout(logout -> logout
                        // Imposta la URL per effettuare il logout.
                        .logoutUrl("/logout")
                        // Reindirizza alla home page dopo il logout.
                        .logoutSuccessUrl("/")
                        // Invalida la sessione HTTP per eliminare i dati dell'utente.
                        .invalidateHttpSession(true)
                        // Elimina il cookie JSESSIONID per rimuovere il tracciamento della sessione.
                        .deleteCookies("JSESSIONID")
                        // Consente a tutti l'accesso alla funzione di logout.
                        .permitAll()
                )

                // Configura la gestione della sessione.
                .sessionManagement(session -> session
                        // Migra la sessione per prevenire attacchi di session fixation.
                        .sessionFixation().migrateSession()
                        // Limita il numero massimo di sessioni per utente a 1.
                        .maximumSessions(1)
                        // Permette il login anche se la sessione precedente viene scaduta.
                        .maxSessionsPreventsLogin(false)
                );

        // Costruisce e restituisce il SecurityFilterChain configurato.
        return http.build();
    }

    // Definisce il bean per il PasswordEncoder che utilizza BCrypt.
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}