require_relative 'Driver'
require_relative 'ArgsChecker'
require_relative 'SeedChecker'
require_relative 'Stats'
require_relative 'CitySim'

game = CitySim::new
game.gameloop