'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "7b456c2bd3b46dd46d2fa68347fd72cf",
"version.json": "9dc334141db45e8b503fc812ae08ed8a",
"index.html": "c03219ecad4d16aadcf337074880c870",
"/": "c03219ecad4d16aadcf337074880c870",
"main.dart.js": "9a3a858247bc5425a9a9b46f02d876e4",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"favicon.png": "379485e6263555828d8c9a5c0a6a810e",
"icons/Icon-192.png": "1b85a2c68b502349bfd91719869f6487",
"icons/Icon-maskable-192.png": "1b85a2c68b502349bfd91719869f6487",
"icons/Icon-maskable-512.png": "415281d1343cfd204d645576d1301266",
"icons/Icon-512.png": "415281d1343cfd204d645576d1301266",
"manifest.json": "aea8eddd6551393e7602ee004060c775",
"assets/AssetManifest.json": "edb31605cea63a229b6027d5d96a49c8",
"assets/NOTICES": "22bee49b654a232b519c6bbbb2a74c6a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "3282f91e14386a01f716bad94b594591",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "990bba9b52fe368e951499c8aa9a529d",
"assets/fonts/MaterialIcons-Regular.otf": "f4e1eb559bee37fbdda65b6a174733a3",
"assets/assets/images/smart_invoice_logo_mobile.svg": "e4fbb522998fef7db6943882c736b2a5",
"assets/assets/images/avatar_placeholder.png": "f4c8122303b4af0acbd9fee49bcf6cb1",
"assets/assets/images/smartinvoice_logo.png": "c1e1137dbfcc6d87d8d9e4b16938b3cc",
"assets/assets/images/background_mobile.png": "e867d195a4208499dfb790098ea5a2e1",
"assets/assets/images/empty_invoice.png": "e62229301bea41563e1de3d38a38a7e0",
"assets/assets/images/bee_daisy_logo.png": "004e1864fbcb53e6b17186ed3060d8c6",
"assets/assets/images/invoice_sent_out.png": "1b4af5b4bb73ca4122735656917fe79f",
"assets/assets/images/gtco_logo.png": "a47e7cbf923e7dca5509e5bc0765c5a7",
"assets/assets/images/receipt.png": "1d79c1570d8d1d67445dfd32e65691bd",
"assets/assets/images/smart_invoice_logo_mobile.png": "37c510db6a53104a78b586b4607509a1",
"assets/assets/images/background.png": "5c9d16cd6ef0748253318eb676660123",
"assets/assets/images/apple.png": "62bf49fd2196d85ae8886502c54c2709",
"assets/assets/images/plus-decoration.svg": "cf504375ea696539525e92e5fcaf0923",
"assets/assets/images/smart_invoice_logo.svg": "255e880feb5c32764799fb1a60fca61e",
"assets/assets/images/app_logo.png": "a5b62de6952fc5b2e7565ad0dcd58dd0",
"assets/assets/images/empty_client.png": "5e5c002fc303576238a7ac7aa68121a6",
"assets/assets/images/smart_invoice_logo.png": "510edb6c5d50c7a9fae875f334bc9311",
"assets/assets/images/google.png": "60dbe988c1749e2eca99b7d5734d4f07",
"assets/assets/images/landing_hero.png": "173f113a3ae7e19f04ba306bff04ae68",
"assets/assets/images/empty_product.png": "1202593ffd5b0fb62f45ad7069813761",
"assets/assets/images/onboarding_background.png": "c58be7478faece951f07702d7ffd8dd5",
"assets/assets/icons/product.svg": "9695775be89a036dc3decf1d27e460f3",
"assets/assets/icons/settings.svg": "46fe243b57b482b98021397309b71a56",
"assets/assets/icons/mail.svg": "9d8194bf822ffc21661544a056c1ccf3",
"assets/assets/icons/dashboard.svg": "72803bc510a4475dafdcd3f2d258186c",
"assets/assets/icons/update.svg": "052fa2d6f1918dd6c70c0543b275a67e",
"assets/assets/icons/draft.svg": "38854eca9c90ae12a8029923341bdfbf",
"assets/assets/icons/client.svg": "5604ea3a72a51ab8c258987a49f9b9cd",
"assets/assets/icons/notification.svg": "7d209935bbafdfe0b462955cc44dd909",
"assets/assets/icons/sent.svg": "a79c7f97b48579f139f98334519f61d7",
"assets/assets/icons/clock.svg": "112fa8bc2c4598bc26d8f2096b90e69e",
"assets/assets/icons/call.svg": "21e3d36e029ebb5558f7d9e724999d29",
"assets/assets/icons/location.svg": "bb1c9e7ba67f303aeb611fa03d76a2b4",
"assets/assets/icons/invoice.svg": "d612f9d31256234460460defd307d2c0",
"assets/assets/icons/help.svg": "6f8815ef8d075dcf644c563a14d91b80",
"assets/assets/icons/timer.svg": "1d856584fc9a889fa0690949929ea349",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
