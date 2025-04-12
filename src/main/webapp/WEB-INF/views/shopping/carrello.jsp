<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Carrello - EcomCaffe</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Navbar unificata */
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
  </style>
</head>
<body>
<!-- Navbar identica a quella della wishlist -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/">EcomCaffe</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav me-3">
        <!-- Icona del carrello -->
        <li class="nav-item">
          <a class="nav-link" href="/carrello">
            <i class="bi bi-cart"></i>
          </a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.utente}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                  ${sessionScope.utente.username}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="/profilo">Profilo</a></li>
                <li><a class="dropdown-item" href="/wishlist">Wishlist</a></li>
                <li><a class="dropdown-item" href="/carrello/storico">Storico</a></li>
                <c:if test="${sessionScope.utente.ruolo eq 'ADMIN'}">
                  <li><a class="dropdown-item" href="/admin">Admin</a></li>
                </c:if>
                <li><a class="dropdown-item" href="/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="guestDropdown" role="button" data-bs-toggle="dropdown">
                Account
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="guestDropdown">
                <li><a class="dropdown-item" href="/login">Login</a></li>
                <li><a class="dropdown-item" href="/registrati">Registrati</a></li>
              </ul>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <h3>Il tuo Carrello</h3>

  <!-- Messaggi di errore -->
  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <c:if test="${not empty cartItems}">
    <table class="table table-bordered">
      <thead class="table-light">
      <tr>
        <th>Prodotto</th>
        <th>Prezzo Unitario</th>
        <th>Quantità</th>
        <th>Subtotale</th>
        <th>Azioni</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="item" items="${cartItems}">
        <tr>
          <td>${item.prodotto.nome}</td>
          <td>${item.prodotto.prezzo}€</td>
          <td>
            <form action="/carrello/aggiorna/${item.prodotto.id}" method="post" class="d-flex align-items-center">
              <input type="number" name="nuovaQuantita"
                     value="${item.quantita}"
                     min="0"
                     max="${item.prodotto.disponibilita}"
                     class="form-control me-2"
                     style="width:100px;">
              <button type="submit" class="btn btn-primary btn-sm">Aggiorna</button>
            </form>
          </td>
          <td class="subtotal">${item.prodotto.prezzo * item.quantita}€</td>
          <td>
            <form action="/carrello/rimuovi/${item.prodotto.id}" method="post">
              <button type="submit" class="btn btn-danger btn-sm">Rimuovi</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      </tbody>
      <tfoot>
      <tr>
        <td colspan="4" class="text-end"><strong>Totale:</strong></td>
        <td><strong id="totale">${totale}€</strong></td>
      </tr>
      <tr>
        <td colspan="5" class="text-end">
          <c:if test="${not empty couponCode}">
            <span id="couponInfo">Coupon: ${couponCode} - ${scontoPercentuale}%</span>
            <button type="button" id="removeCoupon" class="btn btn-warning btn-sm">Rimuovi Coupon</button>
          </c:if>
        </td>
      </tr>
      </tfoot>
    </table>

    <!-- Checkout -->
    <h4>Completa il tuo ordine</h4>
    <form action="/carrello/acquista" method="post">
      <div class="mb-3">
        <label for="indirizzo" class="form-label">Indirizzo di Consegna</label>
        <input type="text" class="form-control" id="indirizzo" name="indirizzo" placeholder="Inserisci il tuo indirizzo" required>
      </div>
      <div class="mb-3">
        <label for="couponCode" class="form-label">Codice Coupon (opzionale)</label>
        <div class="input-group">
          <input type="text" class="form-control" id="couponCode" name="couponCode" placeholder="Inserisci il codice coupon"
                 value="${couponCode}">
          <button type="button" id="applyCoupon" class="btn btn-primary">Applica</button>
        </div>
      </div>
      <button type="submit" class="btn btn-success">Conferma Ordine</button>
    </form>
  </c:if>

  <c:if test="${empty cartItems}">
    <div class="alert alert-info text-center">
      Il tuo carrello è vuoto. Continua gli acquisti!
      <br>
      <a href="/" class="btn btn-primary btn-sm mt-2">Torna alla Home</a>
    </div>
  </c:if>
</div>

<!-- Script per applicare e rimuovere il coupon -->
<script>
  document.getElementById("applyCoupon").addEventListener("click", function() {
    let couponField = document.getElementById("couponCode");
    let coupon = couponField.value.trim();
    if (coupon === "") return;
    fetch("/carrello/calcolaTotale?couponCode=" + encodeURIComponent(coupon))
            .then(response => response.json())
            .then(() => window.location.reload())
            .catch(error => console.error('Errore:', error));
  });

  document.getElementById("removeCoupon").addEventListener("click", function(event) {
    event.preventDefault();
    fetch("/carrello/rimuovi-coupon", { method: "POST" })
            .then(() => window.location.reload())
            .catch(error => console.error('Errore:', error));
  });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
