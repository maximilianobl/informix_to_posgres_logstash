<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome file</title>
  <link rel="stylesheet" href="https://stackedit.io/style.css" />
</head>

<body class="stackedit">
  <div class="stackedit__html"><h1 id="sincronización-de-datos-desde-una-db-informix-hacia-una-db-postgresql"># Sincronización de datos desde una DB Informix hacia una DB PostgreSQL</h1>
<p>Hola! para este proyecto se utilizó <strong>Logstash:8.3.1</strong>, <strong>Informix:14</strong> y <strong>PostgreSQL:9.6</strong>.<br>
El proyecto esta basado en <em>trigger</em> genéricos para el <em>CDC</em>, estos  eventos son enviados a un Stored procedure para generar las novedades en las tablas correspondientes.<br>
Luego desde Logstash, se barren las novedades que se encuentan aín sin procesar, se las transforma y envían hacia PostgreSQL.</p>
<h1 id="compilamos-y-lanzamos-el-proyecto">Compilamos y lanzamos el proyecto</h1>
<pre><code>docker-compose up -d --b
</code></pre>
<blockquote>
<p>Si no funciona la conexión con PostgreSQL, busco el host y lo edito en el .env</p>
</blockquote>
<pre><code>docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres
</code></pre>
<h2 id="genero-las-estructuras-esquemas-tablas-trigger-y-stored-procedure">Genero las estructuras (esquemas, tablas, trigger y stored procedure)</h2>
<p><strong>INFORMIX</strong></p>
<pre><code>docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/esquema.sh'
</code></pre>
<p><strong>Verifico</strong></p>
<p>docker-compose exec informix bash -c ‘/docker-entrypoint-initdb.d/select.sh’</p>
<p><strong>POSTGRESQL</strong></p>
<pre><code>docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/schema'
</code></pre>
<p><strong>Verifico</strong></p>
<pre><code>docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'
</code></pre>
<h2 id="insertamos-los-registros-en-informix">Insertamos los registros en Informix</h2>
<pre><code>docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/insert.sh'
</code></pre>
<p><strong>Verifico en PostgreSQL</strong></p>
<pre><code>docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'
</code></pre>
<h2 id="actualizo-un-registro-en-informix">Actualizo un registro en Informix</h2>
<pre><code>docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/update.sh'
</code></pre>
<p><strong>Verifico en PostgreSQL</strong></p>
<pre><code>docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'
</code></pre>
<h2 id="elimino-un-registro-en-informix">Elimino un registro en Informix</h2>
<pre><code>docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/delete.sh'
</code></pre>
<p><strong>Verifico en PostgreSQL</strong></p>
<pre><code>docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'
</code></pre>
</div>
</body>

</html>
