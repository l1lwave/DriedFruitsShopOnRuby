import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal", "button" ]

  connect() {
     // При підключенні гарантуємо, що scale-0 встановлено для початкової позиції
     this.modalTarget.classList.add('scale-0');
  }

  toggle() {
    // Перевіряємо за inline-стилем
    const isHidden = this.modalTarget.style.display === 'none';

    if (isHidden) {
      // --- ВІДКРИТТЯ ---
      
      // 1. Спочатку робимо видимим (прибираємо display: none)
      this.modalTarget.style.display = 'block'; 
      
      // 2. Запускаємо CSS transition (прибираємо scale-0)
      requestAnimationFrame(() => {
        this.modalTarget.classList.remove('scale-0'); 
      });
      
      // Фокус
      const input = this.modalTarget.querySelector('input[type="text"]');
      if (input) {
        input.focus();
      }

    } else {
      // --- ЗАКРИТТЯ ---
      
      // 1. Спочатку запускаємо анімацію закриття (додаємо scale-0)
      this.modalTarget.classList.add('scale-0');

      // 2. Після завершення CSS transition (300 мс) встановлюємо 'display: none'.
      setTimeout(() => {
        this.modalTarget.style.display = 'none'; // Прибираємо елемент з потоку
      }, 300); 
    }
  }

  // Метод для автоматичного форматування номеру телефону
  formatPhone(event) {
    let input = event.target;
    let value = input.value.replace(/\D/g, ''); 
    
    // Припускаємо український формат з кодом +38
    if (value.length > 0 && !value.startsWith('38')) {
        value = '38' + value;
    }
    if (value.length > 0) {
        value = '+' + value;
    }

    input.value = value;
  }
}