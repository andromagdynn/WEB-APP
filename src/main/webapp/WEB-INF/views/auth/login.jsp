<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - EcomCaffe</title>
    <!-- Inclusione di Bootstrap per lo styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclusione di Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        /* Stile di base per il layout della pagina di login */
        body {
            background-color: #f8f9fa;
        }
        /* Navbar: sfondo scuro e testo bianco */
        .navbar {
            background-color: #343a40;
        }
        .navbar-brand {
            color: white !important;
            font-size: 1.8rem;
            font-weight: bold;
        }
        .nav-link {
            color: white !important;
        }
        .dropdown-menu {
            background-color: white;
        }
        .dropdown-item {
            color: #343a40;
        }
        /* Rimuove la colorazione rossa di default dei campi non validi */
        :invalid {
            box-shadow: none !important;
            outline: none !important;
        }
    </style>
</head>
<body>
<!-- Barra di navigazione principale -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <!-- Logo e link alla home -->
        <a class="navbar-brand" href="/">EcomCaffe</a>
        <!-- Pulsante per il menu mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <!-- Link per la registrazione -->
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="/registrati">Registrati</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Sezione del modulo di login -->
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <!-- Card contenente il modulo -->
            <div class="card shadow">
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">Login</h2>
                    <!-- Modulo di autenticazione: 'novalidate' disabilita la validazione HTML5 -->
                    <form method="post" action="/login" novalidate>
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <!-- Pulsante per inviare il modulo -->
                        <button type="submit" class="btn btn-dark w-100">Login</button>
                    </form>
                    <!-- Link alla pagina di registrazione per i nuovi utenti -->
                    <p class="text-center mt-3">Non hai un account? <a href="/registrati">Registrati</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Inclusione degli script di Bootstrap per le funzionalità dinamiche -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
