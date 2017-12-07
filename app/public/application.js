$wp = false
getConsoleLog()

function getConsoleLog() {
  $xhr = new XMLHttpRequest()
  $xhr.open('GET', '/run/log', true)

  $xhr.onreadystatechange = function() {
    if ($xhr.readyState != 4) return
    data = $xhr.responseText
    if (data != "") {
      $wp = (JSON.parse(data).wp == true)
    } else {
      return
    }
    log = JSON.parse(data).log
    $scr = document.getElementById("console")
    $scr.innerHTML = log
    $scr.scrollTop = $scr.scrollHeight
  }

  $xhr.send()
  if ($wp) { setTimeout(getConsoleLog, 2000) }
}

function startProcess() {
  $wp = true
  getConsoleLog()
  $req = new XMLHttpRequest()
  $req.open('POST', '/run', true)
  $req.send()
}

function contentReloader(url, method) {
  $xhr_config = new XMLHttpRequest()
  $xhr_config.open(method, url, false)
  $xhr_config.send()
  document.body.innerHTML = $xhr_config.responseText
}

function validate() {
  formData = formToJSON(document.getElementById('config'))
  $xhr_validate = new XMLHttpRequest()
  $xhr_validate.open('POST', '/config/validate', false)
  $xhr_validate.setRequestHeader('Content-Type', 'application/json; charset=utf-8')
  $xhr_validate.send(formData)
}

function formToJSON(form) {
  elements = form.querySelectorAll("input, textarea, checkbox")
  data = {}
  for(i=0; i < elements.length; i++) {
    el = elements[i]
    switch(el.type) {
      case 'checkbox':
        if (el.checked) { data[el.name] = true } else { data[el.name] = false }
        break
      case 'submit':
        break
      default:
        if (el.value != '') { data[el.name] = el.value }
    }
  }
  return JSON.stringify(data)
}
