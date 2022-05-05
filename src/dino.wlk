import wollok.game.*
    
object juego{
const rapidez = 300

	method configurar(){
		game.width(12)
		game.height(5)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(manzana)
		game.cellSize(50)
		game.boardGround("fondo.png")

		keyboard.space().onPressDo{self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
} 
	
	method velocidad(){
		return rapidez
 	}

	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		manzana.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
		manzana.detener()
	}

}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER, recolectaste "+ manzana.text() + " manzanas!"
	method textColor() = paleta.negro()
	
}

object paleta {
	const property negro = "000000"
	
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method textColor() = paleta.negro()
	method position() = game.at(game.width()/2, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo + 1
		return tiempo
	}
	
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}

	method detener(){
		game.removeTickEvent("tiempo")
	}
	
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1, suelo.position().y())
	var position = posicionInicial

	method image() = "cactus 2.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(juego.velocidad(),"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
	
}


object suelo{
	
	method position() = game.origin().up(1)
	
}


object dino {
	var vivo = true
	var position = game.at(1, suelo.position().y())	
	
	method image() = "dino2.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule((juego.velocidad())*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch! x_x")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
	
	method textColor() = paleta.negro()
	
}

object manzana{
	const posicionInicial = game.at(game.width()+7, suelo.position().y())
	var posicion = posicionInicial
	var manz = 0 
	
	method image() = "manzana.png"
	method position() = posicion
	
	method iniciar(){
		posicion = posicionInicial
		game.onTick(juego.velocidad(),"moverManzana",{self.mover()})
		manz = 0
	}
	method mover(){
		posicion = posicion.left(1)
		if (posicion.x() == -2)
			posicion = posicionInicial
	}
	method chocar(){
		manz = manz +1 
		posicion = game.at(-1,-1)
		return manz 
}
				
	method text() = manz.toString()
	method textColor() = paleta.negro()
	
	method detener(){
		game.removeTickEvent("moverManzana")
	}
	
}




