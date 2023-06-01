// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"

// Galeria de Bicicletas
const galeria = document.querySelectorAll(".media-gallery img");
const galeriaContainer = document.querySelector(".media-gallery");

function trocarImagem(event) {
  const img = event.currentTarget;
  const media = matchMedia("(min-width: 1000px)").matches;
  if (media) {
    galeriaContainer.prepend(img);
  }
}

function eventosGaleria(img) {
  img.addEventListener("click", trocarImagem);
}

galeria.forEach(eventosGaleria);