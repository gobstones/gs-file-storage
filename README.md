Gobstones File System
======
### File System for Gobstones Web
> Service for managing files and save its into localStorage.

###### Version: 0.0.0

#### deploy

```
npm update
bower update
grunt server
```
### Use

###### Import
```
<link rel="import" href="bower_components/gs-file-system/dist/components/gs-file-system.html">
```

###### And initialize in a local component variable
```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey")
    }

    });
</script>

```

###### Open file
```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey")

      var file = this.storage.open("fileName", this)
             // open return a GsFile
    }

    });
</script>

```

###### Save file
```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey")

      var file = this.storage.open("fileName", this)
             // open return a GsFile
      file.save("fileContent", this)
    }

    });
</script>

```

###### Remove file
```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey")

      var file = this.storage.open("fileName", this)
             // open return a GsFile
      this.storage.remove("fileName")
    }

    });
</script>

```

###### Get all files name Storage in localStorage
```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey")

      listOfFilesNames = this.storage.getAllFilesName()
                         // Return a list of strings with files name
    }

    });
</script>

```

###### Events that let you handle all file system

> All system browser tabs are comunicated.
> Because of this, events may be fired from other tabs.

```
<template>
</template>

<style>
</style>

<script>
  Polymer({
    is: 'demo-file-system',
    
    ready: function() {
      this.storage = GsFileSystem("localStorageKey");

      // Open create a file "on-the-fly" if there is not
      // a file with that name, the file returned is not on
      // localStorage
      var file = this.storage.open("fileName", this);
                  // open return a GsFile
      
      file.save("fileContent", this);

      // event triggered when is saved a new file
      storage.addEventListener('listchange', function(event) {
        // storage.getAllFilesName() because the list has changed
      });
      

      file.save("newfileContent", this);

      // event triggered when is changed the content of a file
      file.addEventListener('change', function(event) {
         // event.target is the new file
         // event.host is the obj responsable for the change
      });

      this.storage.removeFile("fileName");

      // event triggered when file is removed
      file.addEventListener('fileremove', function(event) {
         // this determinates that file is no longer exist in  your system
      });
      
    }


    });
</script>

```

> For performance issues you can do GsFile.close()
> everytime you dont needed when any object use it
> GsFileSystem clean the reference in memory.