#= require trix/views/object_view
#= require trix/views/block_view

{defer} = Trix.Helpers

class Trix.DocumentView extends Trix.ObjectView
  constructor: ->
    super
    @document = @object
    {@element} = @options

  render: ->
    @childViews = []

    @element.removeChild(@element.lastChild) while @element.lastChild

    unless @document.isEmpty()
      previousBlock = null
      previousListTagName = null
      listElement = null

      @document.eachBlock (block, blockIndex) =>
        blockView = @findOrCreateCachedChildView(Trix.BlockView, block, {blockIndex})
        blockElement = blockView.getNodes()[0]
        {listTagName} = blockView.blockConfig

        if listTagName
          if listElement and listTagName is previousListTagName
            listElement.appendChild(blockElement)
          else
            listElement = document.createElement(listTagName)
            listElement.appendChild(blockElement)
            @element.appendChild(listElement)
        else
          listElement = null
          @element.appendChild(blockElement)

        previousBlock = block
        previousListTagName = listTagName

    @didRender()
    @element

  didRender: ->
    defer => @garbageCollectCachedViews()

  focus: ->
    @element.focus()
