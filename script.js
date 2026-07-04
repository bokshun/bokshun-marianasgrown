const config = window.MARIANAS_GROWN;

function productCard(item) {
  return `
    <article class="product-card">
      <img class="product-visual" src="${item.image}" alt="${item.name}">
      <div class="card-body">
        <h3>${item.name}</h3>
        <p class="tag">${item.tag}</p>
        <div class="price-row">
          <span class="price">${item.price}</span>
          <span class="tag">Preorder</span>
        </div>
        <a class="button primary" href="${item.checkoutUrl}" rel="noopener">Buy now</a>
      </div>
    </article>
  `;
}

function releaseCard(item) {
  return `
    <article class="release-card">
      <img class="release-art" src="${item.image}" alt="${item.title}">
      <div class="card-body">
        <h3>${item.title}</h3>
        <p>${item.format}</p>
        <div class="price-row">
          <span class="price">${item.price}</span>
          <span class="tag">Digital</span>
        </div>
        <a class="button secondary" href="${item.checkoutUrl}" rel="noopener">Buy music</a>
      </div>
    </article>
  `;
}

document.getElementById("apparel-products").innerHTML = config.apparel.map(productCard).join("");
document.getElementById("music-releases").innerHTML = config.music.map(releaseCard).join("");
document.getElementById("year").textContent = new Date().getFullYear();
