  // script js

document.addEventListener('DOMContentLoaded',function())
{
  //boton y area de mensaje id
const boton =
document.getElementById('mi boton');
const mensaje =
document.getElementById('mensaje')

  //escuchador de eventos al boton=ruido
botton.addEventListener('click' function() {

    //accion al hacer click
    mensaje.textContent = 'El boton reacciono correctamente';
               mensaje.style.color = 
        'green';
               botton.disabled = true;
               //desactiva boton despues del click
})

}
