<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Registrazione - EcomCaffe</title>
  <!-- Inclusione di Bootstrap per uno stile responsive e moderno -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Inclusione opzionale delle icone Bootstrap -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Stili per la barra di navigazione */
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
    /* Rimuove la colorazione di default dei campi non validi HTML5 */
    :invalid {
      box-shadow: none !important;
      outline: none !important;
    }
  </style>
</head>
<body>
<!-- Barra di navigazione principale con link alla home e al login -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/">EcomCaffe</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="/login">Accedi</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- Sezione principale: modulo per la registrazione di un nuovo account -->
<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow">
        <div class="card-body">
          <h2 class="card-title text-center mb-4">Registrazione</h2>
          <!-- Il form invia i dati al controller per la registrazione (disabilitata la validazione HTML5) -->
          <form method="post" action="/registrati" novalidate>
            <div class="mb-3">
              <label class="form-label">Username</label>
              <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Email</label>
              <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-dark w-100">Registrati</button>
          </form>
          <!-- Link per gli utenti già registrati -->
          <p class="text-center mt-3">Hai già un account? <a href="/login">Accedi</a></p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Inclusione degli script Bootstrap per le funzionalità dinamiche -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
