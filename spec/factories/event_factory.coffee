Factory.define('event')
  .attr('type', 'keydown')
  .attr('metaKey', false)
  .attr('altKey', false)
  .attr('ctrlKey', false)
  .attr('shiftKey', false)
  .attr('keyCode', Math.floor( Math.random() *  124))
