window.onload = function () {
  document.querySelector("#open").addEventListener("click", openFile);
}

function openFile() {
    chrome.fileSystem.chooseEntry(
      {
        type: 'openDirectory'
      },
      function (de) {
        if (de) {
          directoryEntry = de;
          fileList = [];
          console.log(de);
          var dirReader = de.createReader();
          var readEntries = function() {
            dirReader.readEntries (function(results) {
              if (!results.length) {
                console.log("Could not find any entries inside the path");
              } else {
                results.forEach(
                  function(item, indx) {
                    fileList.push(item.fullPath);
                    listResults(fileList);
                  }
                )
              }
            }, errorHandler);
          };
          readEntries();
        } // end of if statement
      }
    );
    execute(fileList);
}


function listResults(entries) {
  // Document fragments can improve performance since they're only appended
  // to the DOM once. Only one browser reflow occurs.
  var fragment = document.createDocumentFragment();
  entries.forEach(function(name, i) {
    var li = document.createElement('li');
    li.innerHTML = ['<span>', name, '</span>'].join('');
    fragment.appendChild(li);
  });
  document.querySelector('#filelist').appendChild(fragment);
}

function execute(entries){
  var xhr = new XMLHttpRequest();
  var url = 'http://localhost:3000/files?session='+session_id;
  xhr.open('post', url, true);
  // xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  xhr.send(JSON.stringify(entries), chrome_session_id: session_id);
  console.log(xhr.response);
  return xhr.response;
};

function errorHandler(e) {
  var msg = '';

  switch (e.code) {
    case FileError.QUOTA_EXCEEDED_ERR:
      msg = 'QUOTA_EXCEEDED_ERR';
      break;
    case FileError.NOT_FOUND_ERR:
      msg = 'NOT_FOUND_ERR';
      break;
    case FileError.SECURITY_ERR:
      msg = 'SECURITY_ERR';
      break;
    case FileError.INVALID_MODIFICATION_ERR:
      msg = 'INVALID_MODIFICATION_ERR';
      break;
    case FileError.INVALID_STATE_ERR:
      msg = 'INVALID_STATE_ERR';
      break;
    default:
      msg = 'Unknown Error';
      break;
  };
  console.log('Error: ' + msg);

}
