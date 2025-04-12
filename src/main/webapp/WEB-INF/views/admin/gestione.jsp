<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Gestione - EcomCaffe Admin</title>
  <!-- Sezione: Inclusione di Bootstrap 5 e Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body { background-color: #f8f9fa; }
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
    .table th, .table td { vertical-align: middle; }
  </style>
</head>
<body>
<!-- Sezione: Navbar dell'area amministrativa -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin">EcomCaffe - Pannello Admin</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav me-3">
        <li class="nav-item">
          <a class="nav-link" href="/carrello"><i class="bi bi-cart"></i></a>
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

<!-- Sezione: Contenuto principale - Pannello di gestione admin -->
<div class="container mt-4">
  <h1 class="mb-4">Pannello di Gestione Admin</h1>

  <!-- Sezione: Gestione Catalogo Prodotti -->
  <div class="accordion mb-4" id="accordionProdotti">
    <div class="accordion-item">
      <h2 class="accordion-header" id="headingProdotti">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProdotti">
          Gestione Catalogo Prodotti
        </button>
      </h2>
      <div id="collapseProdotti" class="accordion-collapse collapse">
        <div class="accordion-body">
          <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#modalAggiungiProdotto">
            <i class="bi bi-plus-lg"></i> Aggiungi Prodotto
          </button>
          <table class="table table-bordered">
            <thead class="table-dark">
            <tr>
              <th>ID</th>
              <th>Nome</th>
              <th>Descrizione</th>
              <th>Prezzo</th>
              <th>Disponibilità</th>
              <th>Categoria</th>
              <th>Brand</th>
              <th>In Vetrina</th>
              <th>Azioni</th>
            </tr>
            </thead>
            <tbody id="tabellaProdotti">
            <c:forEach var="prodotto" items="${prodotti}">
              <tr id="prodotto-${prodotto.id}">
                <td>${prodotto.id}</td>
                <td>${prodotto.nome}</td>
                <td>${prodotto.descrizione}</td>
                <td>${prodotto.prezzo}€</td>
                <td>${prodotto.disponibilita}</td>
                <td>${prodotto.categoria.nome}</td>
                <td>${prodotto.brand.nome}</td>
                <td>
                  <c:choose>
                    <c:when test="${prodotto.inVetrina}">Si</c:when>
                    <c:otherwise>No</c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <button class="btn btn-sm btn-warning"
                          onclick="openEditProductModal(${prodotto.id},'${prodotto.nome}','${prodotto.descrizione}',${prodotto.prezzo},${prodotto.disponibilita},${prodotto.categoria.id},${prodotto.brand.id}, ${prodotto.inVetrina}, '${prodotto.immagine}')">
                    <i class="bi bi-pencil"></i> Modifica
                  </button>
                  <button class="btn btn-sm btn-danger" onclick="blockProduct(${prodotto.id})">
                    <i class="bi bi-lock"></i> Blocca
                  </button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- Sezione: Gestione Categorie -->
  <div class="accordion mb-4" id="accordionCategorie">
    <div class="accordion-item">
      <h2 class="accordion-header" id="headingCategorie">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategorie">
          Gestione Categorie
        </button>
      </h2>
      <div id="collapseCategorie" class="accordion-collapse collapse">
        <div class="accordion-body">
          <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#modalAggiungiCategoria">
            <i class="bi bi-plus-lg"></i> Aggiungi Categoria
          </button>
          <table class="table table-bordered">
            <thead class="table-dark">
            <tr>
              <th>ID</th>
              <th>Nome Categoria</th>
              <th>Azioni</th>
            </tr>
            </thead>
            <tbody id="tabellaCategorie">
            <c:forEach var="categoria" items="${categorie}">
              <tr id="categoria-${categoria.id}">
                <td>${categoria.id}</td>
                <td>${categoria.nome}</td>
                <td>
                  <button class="btn btn-sm btn-warning" onclick="openEditCategoryModal(${categoria.id},'${categoria.nome}')">
                    <i class="bi bi-pencil"></i> Modifica
                  </button>
                  <button class="btn btn-sm btn-danger" onclick="deleteCategory(${categoria.id})">
                    <i class="bi bi-trash"></i> Elimina
                  </button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- Sezione: Gestione Brand -->
  <div class="accordion mb-4" id="accordionBrand">
    <div class="accordion-item">
      <h2 class="accordion-header" id="headingBrand">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseBrand">
          Gestione Brand
        </button>
      </h2>
      <div id="collapseBrand" class="accordion-collapse collapse">
        <div class="accordion-body">
          <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#modalAggiungiBrand">
            <i class="bi bi-plus-lg"></i> Aggiungi Brand
          </button>
          <table class="table table-bordered">
            <thead class="table-dark">
            <tr>
              <th>ID</th>
              <th>Nome Brand</th>
              <th>Azioni</th>
            </tr>
            </thead>
            <tbody id="tabellaBrand">
            <c:forEach var="b" items="${brand}">
              <tr id="brand-${b.id}">
                <td>${b.id}</td>
                <td>${b.nome}</td>
                <td>
                  <button class="btn btn-sm btn-warning" onclick="openEditBrandModal(${b.id},'${b.nome}')">
                    <i class="bi bi-pencil"></i> Modifica
                  </button>
                  <button class="btn btn-sm btn-danger" onclick="deleteBrand(${b.id})">
                    <i class="bi bi-trash"></i> Elimina
                  </button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Sezione: Modali per l'inserimento e la modifica dei dati -->

<!-- Modal per Aggiunta Prodotto -->
<div class="modal fade" id="modalAggiungiProdotto" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form id="formAggiungiProdotto">
        <div class="modal-header">
          <h5 class="modal-title">Aggiungi Nuovo Prodotto</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="nomeProdotto" class="form-label">Nome Prodotto</label>
            <input type="text" class="form-control" id="nomeProdotto" name="nome" required>
          </div>
          <div class="mb-3">
            <label for="descrizioneProdotto" class="form-label">Descrizione</label>
            <textarea class="form-control" id="descrizioneProdotto" name="descrizione" rows="3" required></textarea>
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="prezzoProdotto" class="form-label">Prezzo</label>
              <input type="number" step="0.01" class="form-control" id="prezzoProdotto" name="prezzo" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="disponibilitaProdotto" class="form-label">Disponibilità</label>
              <input type="number" class="form-control" id="disponibilitaProdotto" name="disponibilita" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="immagineProdotto" class="form-label">URL Immagine</label>
              <input type="text" class="form-control" id="immagineProdotto" name="immagine" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="inVetrinaProdotto" class="form-label">In Vetrina</label>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="inVetrinaProdotto" name="inVetrina" value="true">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="categoriaSelectAggiungi" class="form-label">Categoria</label>
              <select id="categoriaSelectAggiungi" name="categoria.id" class="form-select" required>
                <option value="">Seleziona Categoria</option>
                <c:forEach var="cat" items="${categorie}">
                  <option value="${cat.id}">${cat.nome}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="brandSelectAggiungi" class="form-label">Brand</label>
              <select id="brandSelectAggiungi" name="brand.id" class="form-select" required>
                <option value="">Seleziona Brand</option>
                <c:forEach var="b" items="${brand}">
                  <option value="${b.id}">${b.nome}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="salvaAggiuntaProdotto()">Aggiungi</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal per Modifica Prodotto -->
<div class="modal fade" id="modalEditProdotto" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form id="formEditProdotto">
        <div class="modal-header">
          <h5 class="modal-title">Modifica Prodotto</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="editProdottoId" name="id">
          <div class="mb-3">
            <label for="editProdottoNome" class="form-label">Nome Prodotto</label>
            <input type="text" class="form-control" id="editProdottoNome" name="nome" required>
          </div>
          <div class="mb-3">
            <label for="editProdottoDescrizione" class="form-label">Descrizione</label>
            <textarea class="form-control" id="editProdottoDescrizione" name="descrizione" rows="3" required></textarea>
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="editProdottoPrezzo" class="form-label">Prezzo</label>
              <input type="number" step="0.01" min="0" class="form-control" id="editProdottoPrezzo" name="prezzo" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="editProdottoDisponibilita" class="form-label">Disponibilità</label>
              <input type="number" class="form-control" min="0" id="editProdottoDisponibilita" name="disponibilita" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="editProdottoImmagine" class="form-label">URL Immagine</label>
              <input type="text" class="form-control" id="editProdottoImmagine" name="immagine" required>
            </div>
            <div class="col-md-3 mb-3">
              <label for="editProdottoInVetrina" class="form-label">In Vetrina</label>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="editProdottoInVetrina" name="inVetrina" value="true">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="editProdottoCategoria" class="form-label">Categoria</label>
              <select id="editProdottoCategoria" name="categoria.id" class="form-select" required>
                <option value="">Seleziona Categoria</option>
                <c:forEach var="cat" items="${categorie}">
                  <option value="${cat.id}">${cat.nome}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="editProdottoBrand" class="form-label">Brand</label>
              <select id="editProdottoBrand" name="brand.id" class="form-select" required>
                <option value="">Seleziona Brand</option>
                <c:forEach var="b" items="${brand}">
                  <option value="${b.id}">${b.nome}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="salvaModificaProdotto()">Salva</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal per Aggiunta Categoria -->
<div class="modal fade" id="modalAggiungiCategoria" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="formAggiungiCategoria">
        <div class="modal-header">
          <h5 class="modal-title">Aggiungi Nuova Categoria</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Chiudi"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="nomeCategoria" class="form-label">Nome Categoria</label>
            <input type="text" class="form-control" id="nomeCategoria" name="nome" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="salvaAggiuntaCategoria()">Aggiungi</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal per Aggiunta Brand -->
<div class="modal fade" id="modalAggiungiBrand" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="formAggiungiBrand">
        <div class="modal-header">
          <h5 class="modal-title">Aggiungi Nuovo Brand</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Chiudi"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="nomeBrand" class="form-label">Nome Brand</label>
            <input type="text" class="form-control" id="nomeBrand" name="nome" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="salvaAggiuntaBrand()">Aggiungi</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        </div>
      </form>
    </div>
  </div>
</div>
</div>

<!-- Sezione: Script Ajax e funzioni JavaScript per le operazioni dinamiche -->
<script>
  // Mostra la modale di modifica prodotto e popola i campi con i dati correnti
  function openEditProductModal(id, nome, descrizione, prezzo, disponibilita, categoriaId, brandId, inVetrina, immagine) {
    document.getElementById("editProdottoId").value = id;
    document.getElementById("editProdottoNome").value = nome;
    document.getElementById("editProdottoDescrizione").value = descrizione;
    document.getElementById("editProdottoPrezzo").value = prezzo;
    document.getElementById("editProdottoDisponibilita").value = disponibilita;
    document.getElementById("editProdottoImmagine").value = immagine;
    document.getElementById("editProdottoCategoria").value = categoriaId;
    document.getElementById("editProdottoBrand").value = brandId;
    document.getElementById("editProdottoInVetrina").checked = inVetrina;
    var modal = new bootstrap.Modal(document.getElementById("modalEditProdotto"));
    modal.show();
  }

  // Invia via Ajax i dati per aggiornare un prodotto
  function salvaModificaProdotto() {
    var form = document.getElementById("formEditProdotto");
    var formData = new FormData(form);

    fetch('/admin/prodotto/update', {
      method: 'POST',
      body: new URLSearchParams(formData)
    })
            .then(response => response.json())
            .then(data => {
              if(data.status === "success") {
                alert(data.message);
                location.reload();
              } else {
                alert("Errore: " + data.message);
              }
            })
            .catch(error => console.error("Errore nella chiamata Ajax:", error));
  }

  // Invia via Ajax i dati per aggiungere un nuovo prodotto
  function salvaAggiuntaProdotto() {
    var form = document.getElementById("formAggiungiProdotto");
    var formData = new FormData(form);

    fetch('/admin/prodotto/aggiungi', {
      method: 'POST',
      body: new URLSearchParams(formData)
    })
            .then(response => response.json())
            .then(data => {
              if(data.status === "success") {
                alert(data.message);
                location.reload();
              } else {
                alert("Errore: " + data.message);
              }
            })
            .catch(error => console.error("Errore nella chiamata Ajax:", error));
  }

  // Blocca un prodotto dopo conferma via Ajax
  function blockProduct(id) {
    if(confirm("Sei sicuro di voler bloccare questo prodotto?")) {
      fetch('/admin/prodotto/block?id=' + id, { method: 'POST' })
              .then(response => response.json())
              .then(data => {
                if(data.status === "success") {
                  alert(data.message);
                  location.reload();
                } else {
                  alert("Errore: " + data.message);
                }
              })
              .catch(error => console.error("Errore nella chiamata Ajax:", error));
    }
  }

  // Gestione delle operazioni sulle categorie
  function openEditCategoryModal(id, nome) {
    var nuovoNome = prompt("Modifica il nome della categoria:", nome);
    if(nuovoNome) {
      fetch('/admin/categoria/update', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'id=' + id + '&nome=' + encodeURIComponent(nuovoNome)
      })
              .then(response => response.json())
              .then(data => {
                if(data.status === "success"){
                  alert(data.message);
                  location.reload();
                } else {
                  alert("Errore: " + data.message);
                }
              });
    }
  }

  function deleteCategory(id) {
    if(confirm("Confermi l'eliminazione di questa categoria?")) {
      fetch('/admin/categoria/delete?id=' + id, { method: 'POST' })
              .then(response => response.json())
              .then(data => {
                if(data.status === "success"){
                  alert(data.message);
                  location.reload();
                } else {
                  alert("Errore: " + data.message);
                }
              });
    }
  }

  // Gestione delle operazioni sui brand
  function openEditBrandModal(id, nome) {
    var nuovoNome = prompt("Modifica il nome del brand:", nome);
    if(nuovoNome) {
      fetch('/admin/brand/update', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'id=' + id + '&nome=' + encodeURIComponent(nuovoNome)
      })
              .then(response => response.json())
              .then(data => {
                if(data.status === "success"){
                  alert(data.message);
                  location.reload();
                } else {
                  alert("Errore: " + data.message);
                }
              });
    }
  }

  function deleteBrand(id) {
    if(confirm("Confermi l'eliminazione di questo brand?")) {
      fetch('/admin/brand/delete?id=' + id, { method: 'POST' })
              .then(response => response.json())
              .then(data => {
                if(data.status === "success"){
                  alert(data.message);
                  location.reload();
                } else {
                  alert("Errore: " + data.message);
                }
              });
    }
  }

  // Invia via Ajax i dati per aggiungere una nuova categoria
  function salvaAggiuntaCategoria() {
    var form = document.getElementById("formAggiungiCategoria");
    var formData = new FormData(form);
    fetch('/admin/categoria/aggiungi', {
      method: 'POST',
      body: new URLSearchParams(formData)
    })
            .then(response => response.json())
            .then(data => {
              if(data.status === "success"){
                alert(data.message);
                location.reload();
              } else {
                alert("Errore: " + data.message);
              }
            })
            .catch(error => console.error("Errore nella chiamata Ajax:", error));
  }

  // Invia via Ajax i dati per aggiungere un nuovo brand
  function salvaAggiuntaBrand() {
    var form = document.getElementById("formAggiungiBrand");
    var formData = new FormData(form);
    fetch('/admin/brand/aggiungi', {
      method: 'POST',
      body: new URLSearchParams(formData)
    })
            .then(response => response.json())
            .then(data => {
              if(data.status === "success"){
                alert(data.message);
                location.reload();
              } else {
                alert("Errore: " + data.message);
              }
            })
            .catch(error => console.error("Errore nella chiamata Ajax:", error));
  }
</script>

<!-- Inclusione di Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>