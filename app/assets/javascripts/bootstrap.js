// Trap Enter for modal submission
$(function() {
    let node = $('*[data-trap-enter]')
    let btn = node.attr('data-trap-enter')
    if(node && btn) {
        node.keypress(function (e) {
            if (e.which == 13) {
                e.preventDefault()
                $(e.currentTarget).find('#' + btn).click()
            }
        })
    }
})
