# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  defaults:
    inProgress: true

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    @get('playerHand') .on("bust", @handlePlayerBust, @)
    @get('dealerHand') .on("bust", @handleDealerBust,@)
    @get('playerHand') .on("stand", @handleStand,@)
    @dealCards()

  dealCards: () ->
    @get('playerHand').hit()
    @get('playerHand').hit()
    @get('dealerHand').hit().flip()
    @get('dealerHand').hit()

  handlePlayerBust: () ->
    @gameOver('lose')

  handleDealerBust: () ->
    @gameOver('win')

  handleStand: () ->
    @get('dealerHand') .at(0).flip()
    if @get('dealerHand').getMaxScore() < 17
      @get('dealerHand') .hit()
    else
      if @get('inProgress') then @checkScore()

  gameOver: (result) ->
    console.log result
    @trigger('gameOver', result)
    @set('inProgress', false)

  checkScore: () ->
    playerScore = @get('playerHand') .getMaxScore()
    dealerScore = @get('dealerHand') .getMaxScore()
    if playerScore > dealerScore
      @gameOver('win')
    else if playerScore == dealerScore
      @gameOver('split pot')
    else @gameOver('lose')

  newGame: () ->
    @initialize()
    @set('inProgress', true)
    @trigger "newHand"



#call solitaire victory after dealer finishes hitting
#disable hit buton after stand
#tell player when they win or lose, then wait a second before solitairevictory
#deck slide out on new game

