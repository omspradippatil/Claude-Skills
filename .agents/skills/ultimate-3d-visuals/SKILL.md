---
name: ultimate-3d-visuals
description: Consolidated ultimate skill containing expert knowledge for 3d visuals. Use this for all tasks in this domain.
---

# Ultimate 3D Visuals

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request.

## Skill Catalog

### globe-gl
**Description:** Use when implementing globe.gl (Globe.GL) for 3D globe data visualization with WebGL/ThreeJS, including setup, data layers (points, arcs, polygons, labels), and integration patterns in plain HTML or React.


#### Globe.GL Skill

##### Workflow
1. Confirm environment (plain HTML, framework, React bindings) and the data layers needed.
2. Provide a minimal quick-start snippet plus the layer-specific fields.
3. Add interactions or extra layers only if requested.
4. Call out container sizing and performance considerations.

##### Quick start (ESM)
```html
<script type="module">
  import Globe from 'globe.gl';

  const myGlobe = new Globe(document.getElementById('globe'))
    .globeImageUrl(myImageUrl)
    .pointsData(myData);
</script>
```

##### Quick start (script tag)
```html
<script src="//cdn.jsdelivr.net/npm/globe.gl"></script>
<script>
  const myGlobe = new Globe(document.getElementById('globe'))
    .globeImageUrl(myImageUrl)
    .pointsData(myData);
</script>
```

##### Common layers to mention
- Points
- Arcs
- Polygons
- Paths
- Heatmaps and hex bins
- Labels or HTML elements
- 3D objects and custom layers

##### Practical tips
- Size the container with CSS; the globe fills its parent element.
- Reduce point count or size for performance on mobile.
- Use a darker globe texture for neon-style data overlays.

##### Questions to ask when specs are missing
- Which layers do you need (points, arcs, polygons, labels)?
- What should the globe size be on desktop vs mobile?
- Do you want drag/rotate interactions or a static globe?
- Is this plain HTML, React (`react-globe.gl`), or another framework?


---

### globe-particles
**Description:** Create a globe-like 3D particle visualization with a dense luminous spherical core and thinner orbital ring or flattened disc. Use when a design needs a premium planetary, orbital, synthesized data-globe effect rendered with real WebGL/Three.js particles, not generic starfields or full page layout changes.


#### Globe Particles

##### Scope
- Apply only to a globe-like 3D particle visualization.
- Do not change full page layout, copy, or unrelated motion systems.
- Use for planetary, orbital, infrastructure, or synthesized data-globe effects.
- Keep the core neutral or white-hot and derive ring/glow accents from the design's primary color.

##### Visual Target
- Dense spherical core of luminous points.
- Thinner outer orbital ring or flattened disc around the sphere.
- Clear globe silhouette with tilt, depth, and layered particle density.
- Dark atmospheric background, restrained glow, clean structure, and subtle sci-fi depth.
- Premium and cinematic, not playful or noisy.

##### HTML And CSS

```html
<div class="globe-particles-shell">
  <canvas class="globe-particles-canvas" data-globe-particles></canvas>
</div>
```

```css
.globe-particles-shell {
  position: relative;
  width: min(100%, 760px);
  aspect-ratio: 1 / 1;
}

.globe-particles-canvas {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  display: block;
  pointer-events: none;
}
```

##### Particle Shader
Use circular shader points so particles stay crisp and luminous.

```js
const globeParticleVertex = `
attribute float a_size;
attribute float a_layer;

uniform float u_time;
uniform float u_pointSize;

varying float v_layer;
varying float v_depth;
varying float v_falloff;

void main() {
  vec3 pos = position;
  float breathe = 1.0 + sin(u_time * 0.65 + a_layer * 4.0) * 0.012;
  pos *= breathe;

  vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
  gl_PointSize = u_pointSize * a_size * (1.0 / max(0.18, -mvPosition.z));
  gl_Position = projectionMatrix * mvPosition;

  v_layer = a_layer;
  v_depth = smoothstep(-1.8, 1.8, pos.z);
  v_falloff = smoothstep(2.45, 0.25, length(pos));
}
`;

const globeParticleFragment = `
precision highp float;

uniform vec3 u_coreColor;
uniform vec3 u_accentColor;

varying float v_layer;
varying float v_depth;
varying float v_falloff;

void main() {
  vec2 uv = gl_PointCoord - 0.5;
  float d = length(uv);
  float alpha = smoothstep(0.5, 0.0, d);
  alpha *= alpha;

  vec3 color = mix(u_coreColor, u_accentColor, smoothstep(0.35, 1.0, v_layer));
  color += vec3(1.0) * v_depth * 0.08;
  color = mix(color * 0.42, color, clamp(v_falloff + v_layer * 0.28, 0.0, 1.0));
  alpha *= mix(0.52, 1.0, clamp(v_falloff + v_layer * 0.24, 0.0, 1.0));

  gl_FragColor = vec4(color, alpha);
}
`;
```

##### Three.js Recipe

```js
import * as THREE from "three";

function hexToRgb01(hex) {
  const clean = hex.replace("#", "").trim();
  const value = clean.length === 3
    ? clean.split("").map((char) => char + char).join("")
    : clean;

  return new THREE.Color(
    parseInt(value.slice(0, 2), 16) / 255,
    parseInt(value.slice(2, 4), 16) / 255,
    parseInt(value.slice(4, 6), 16) / 255
  );
}

function buildGlobeParticleGeometry(options = {}) {
  const sphereCount = options.sphereCount || 2600;
  const ringCount = options.ringCount || 1300;
  const radius = options.radius || 1.35;
  const ringRadius = options.ringRadius || 2.05;
  const ringThickness = options.ringThickness || 0.12;
  const total = sphereCount + ringCount;

  const positions = new Float32Array(total * 3);
  const sizes = new Float32Array(total);
  const layers = new Float32Array(total);

  for (let i = 0; i < sphereCount; i++) {
    const z = Math.random() * 2 - 1;
    const theta = Math.random() * Math.PI * 2;
    const r = radius * (0.58 + Math.pow(Math.random(), 0.42) * 0.42);
    const root = Math.sqrt(1 - z * z);
    const index = i * 3;

    positions[index] = Math.cos(theta) * root * r;
    positions[index + 1] = Math.sin(theta) * root * r;
    positions[index + 2] = z * r;
    sizes[i] = 0.72 + Math.random() * 0.72;
    layers[i] = Math.random() * 0.28;
  }

  for (let i = 0; i < ringCount; i++) {
    const pointIndex = sphereCount + i;
    const angle = Math.random() * Math.PI * 2;
    const r = ringRadius + (Math.random() - 0.5) * ringThickness;
    const y = (Math.random() - 0.5) * ringThickness * 0.58;
    const index = pointIndex * 3;

    positions[index] = Math.cos(angle) * r;
    positions[index + 1] = y;
    positions[index + 2] = Math.sin(angle) * r;
    sizes[pointIndex] = 0.62 + Math.random() * 0.58;
    layers[pointIndex] = 0.72 + Math.random() * 0.28;
  }

  const geometry = new THREE.BufferGeometry();
  geometry.setAttribute("position", new THREE.BufferAttribute(positions, 3));
  geometry.setAttribute("a_size", new THREE.BufferAttribute(sizes, 1));
  geometry.setAttribute("a_layer", new THREE.BufferAttribute(layers, 1));
  return geometry;
}

function initGlobeParticles(canvas, options = {}) {
  if (!canvas) return () => {};

  const renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: true,
    alpha: true,
  });
  renderer.setClearColor(0x000000, 0);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, options.maxDpr || 1.6));
  renderer.outputColorSpace = THREE.SRGBColorSpace;

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100);
  camera.position.set(0, 0, options.cameraDistance || 5.6);

  const accent = options.accentColor
    ? new THREE.Color(options.accentColor)
    : hexToRgb01(getComputedStyle(document.documentElement).getPropertyValue("--brand-accent").trim() || "#8b5cf6");

  const geometry = buildGlobeParticleGeometry(options);
  const material = new THREE.ShaderMaterial({
    vertexShader: globeParticleVertex,
    fragmentShader: globeParticleFragment,
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    uniforms: {
      u_time: { value: 0 },
      u_pointSize: { value: options.pointSize || 18 },
      u_coreColor: { value: new THREE.Color(options.coreColor || 0xf8fafc) },
      u_accentColor: { value: accent },
    },
  });

  const particles = new THREE.Points(geometry, material);
  particles.rotation.x = options.tiltX ?? -0.42;
  particles.rotation.z = options.tiltZ ?? 0.22;
  scene.add(particles);

  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const pointer = new THREE.Vector2(0, 0);
  let rafId = 0;

  function resize() {
    const width = Math.max(1, canvas.clientWidth);
    const height = Math.max(1, canvas.clientHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, options.maxDpr || 1.6));
    renderer.setSize(width, height, false);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  }

  function handlePointerMove(event) {
    const rect = canvas.getBoundingClientRect();
    pointer.x = ((event.clientX - rect.left) / rect.width - 0.5) * 2;
    pointer.y = ((event.clientY - rect.top) / rect.height - 0.5) * 2;
  }

  function render(time = 0) {
    const t = time * 0.001;
    material.uniforms.u_time.value = t;

    const mouseStrength = options.mouseStrength ?? 0.08;
    const breath = reduceMotion ? 0 : Math.sin(t * 0.55) * 0.045;
    particles.rotation.y = t * (options.rotationSpeed || 0.12);
    particles.rotation.x = (options.tiltX ?? -0.42) + pointer.y * mouseStrength;
    particles.rotation.z = (options.tiltZ ?? 0.22) + pointer.x * mouseStrength;
    particles.scale.setScalar(1 + breath);

    renderer.render(scene, camera);
    if (!reduceMotion) rafId = requestAnimationFrame(render);
  }

  function handleResize() {
    cancelAnimationFrame(rafId);
    resize();
    render();
  }

  resize();
  render();
  window.addEventListener("resize", handleResize);
  window.addEventListener("pointermove", handlePointerMove);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
    window.removeEventListener("pointermove", handlePointerMove);
    geometry.dispose();
    material.dispose();
    renderer.dispose();
  };
}

const cleanupGlobe = initGlobeParticles(document.querySelector("[data-globe-particles]"), {
  sphereCount: 2600,
  ringCount: 1300,
  accentColor: "#8b5cf6",
  radius: 1.35,
  ringRadius: 2.05,
  rotationSpeed: 0.12,
  mouseStrength: 0.08,
});
```

##### Tuning Knobs
- Density: tune `sphereCount` and `ringCount` separately.
- Scale: tune `radius`, `ringRadius`, `ringThickness`, and `cameraDistance`.
- Color: keep `coreColor` neutral; derive `accentColor` from the brand primary.
- Motion: tune `rotationSpeed`, `tiltX`, `tiltZ`, `mouseStrength`, and breathing amplitude.
- Glow: tune `pointSize`, additive blending, and particle count so the shape stays crisp.
- Performance: lower particle counts or cap `maxDpr` before changing the visual structure.

##### Taste Rules
- The silhouette must read as a globe, not a loose starfield.
- The ring should feel orbital and tilted, not like a flat decorative underline.
- Use restrained glow; let density and depth create the premium feel.
- Keep mouse response gentle so the object drifts rather than swings.
- Put the globe over a dark background or inside a dark atmospheric shell.

##### Avoid
- Generic starfield noise with no spherical structure.
- Oversized particles or bloom that destroys the globe silhouette.
- Hardcoded accent colors when the design has a clear primary color.
- Wild cursor interaction or fast spinning.
- Dense fog that turns the object into a blurry blob.

##### Quick Checks
- Sphere and ring are distinct particle populations.
- Core reads mostly neutral or white-hot.
- Accent color appears on ring, highlights, or glow.
- Tilt reveals the ring and globe depth.
- Reduced motion renders a still or near-still object.
- Geometry, material, renderer, listeners, and RAF are cleaned up.


---

### threejs
**Description:** Use when building or debugging interactive 3D scenes on the web with Three.js (scene/camera/renderer, lights/materials, GLTF loading, controls, performance). Helpful for designers shipping 3D UI moments.


#### Three.js — WebGL 3D Scenes Skill

##### When to use
- Real 3D: product spins, interactive hero scenes, shaders/material effects, 3D data viz
- You need full control beyond “background effects”
- You can budget time for asset pipeline + performance tuning

##### Core mental model
- Create:
  - `Scene` (root graph)
  - `Camera` (Perspective/Orthographic)
  - `Renderer` (`WebGLRenderer`)
  - `Mesh` = `Geometry` + `Material`
  - Lights (if using non-unlit materials)
- Render loop:
  - `requestAnimationFrame(animate)`
  - Update time-based animations, controls, mixers, then `renderer.render(scene, camera)`

##### Key APIs/patterns
- Setup:
  - `const renderer = new THREE.WebGLRenderer({ canvas, antialias, alpha })`
  - `renderer.setSize(width, height, false)`
  - `renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))`
- Camera:
  - `camera.aspect = width / height; camera.updateProjectionMatrix()`
- Scene graph:
  - `scene.add(object)` / `object.position/rotation/scale`
- Loading assets:
  - `GLTFLoader` (models), `TextureLoader` (images), `DRACOLoader` (compressed glTF)
- Controls (common):
  - `OrbitControls` (debug/product), `PointerLockControls` (FPS), custom pointer handlers
- Cleanup (important in SPAs):
  - `geometry.dispose()`, `material.dispose()`, `texture.dispose()`, `renderer.dispose()`
  - Remove event listeners; cancel RAF.

##### Common pitfalls
- Not handling resize → stretched/cropped rendering
- Too high devicePixelRatio → mobile GPU meltdown
- Leaking WebGL resources (not disposing) → crashes after route changes
- Loading huge textures/models → slow start; use compressed textures, Draco/KTX2, smaller maps
- Using too many lights/shadows → expensive; fake lighting with baked textures when possible

##### Quick recipes

###### 1) Minimal spinning cube
```js
import * as THREE from "three";

const canvas = document.querySelector("#c");
const renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 100);
camera.position.set(0, 0, 4);

const geom = new THREE.BoxGeometry(1, 1, 1);
const mat = new THREE.MeshStandardMaterial({ color: 0x7c3aed });
const mesh = new THREE.Mesh(geom, mat);
scene.add(mesh);

scene.add(new THREE.AmbientLight(0xffffff, 0.8));
const dir = new THREE.DirectionalLight(0xffffff, 0.8);
dir.position.set(2, 2, 2);
scene.add(dir);

function resize() {
  const w = canvas.clientWidth;
  const h = canvas.clientHeight;
  renderer.setSize(w, h, false);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  camera.aspect = w / h;
  camera.updateProjectionMatrix();
}
window.addEventListener("resize", resize);
resize();

function animate(t) {
  mesh.rotation.y = t * 0.0006;
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}
requestAnimationFrame(animate);
```

###### 2) Respect reduced motion
- If `prefers-reduced-motion: reduce`, render a still frame (no RAF) or slow updates.

##### What to ask the user
- Is this decorative (hero) or functional 3D (product viewer)?
- Target devices: mobile? older iPhones?
- Asset format availability (glTF, HDRI, textures) and file size constraints
- Accessibility/reduced motion requirements


---

### threejs-landscape
**Description:** Build a live Three.js landscape that stays quiet behind a subject — a noise heightfield on a polar grid so resolution follows the lens, ground coloured by slope and moisture rather than by texture, instanced GPU grass whose wind costs nothing on the CPU, scattered stones, a gradient sky dome, a star field you can actually see, and a time-of-day system that cross-fades instead of cutting. Use for hero backdrops, product stages, scroll worlds, or any scene where a building, object, or figure has to sit in a place rather than float on a gradient.


#### Three.js Landscape

A backdrop has one job: make the subject look like it is somewhere. Everything here is chosen so the landscape reads at a glance and then gets out of the way.

Reach for `threejs-weather` to put rain, storm or snow on top of it, and `threejs-towers` when the subject standing in it is architecture.

##### Ring the camera with a polar grid

Do not build a square heightfield. A long lens sees a narrow wedge, so a square grid spends most of its triangles behind the camera and still runs out of resolution at the horizon.

Sample on a polar grid centred under the camera, with radial rings that get further apart as they recede:

```js
const AN = 900, RN = 52, R0 = 2.0, R1 = 700;   // angular, radial, near, far
for (let r = 0; r <= RN; r++) {
  const t = r / RN;
  const rad = R0 + (R1 - R0) * Math.pow(t, 2.4);   // dense near, sparse far
  for (let a = 0; a < AN; a++) {
    const th = a / AN * Math.PI * 2;
    push(Math.cos(th) * rad, landH(x, z), Math.sin(th) * rad);
  }
}
```

Two thousand triangles near the subject beat two hundred thousand spread evenly. `pow(t, 2.4)` is the whole trick: every ring covers roughly the same number of screen pixels.

**Watch the winding.** On a polar grid it is easy to wind every quad the wrong way and end up looking at the sky through the ground. Index as `(a0, b1, b0, a0, a1, b1)` and check by orbiting under the horizon once, deliberately, before you build anything else on top.

##### Warp the domain before you layer octaves

Plain fBm reads as crumpled paper. Warping the sample position with another noise field before you evaluate it is the single biggest step toward terrain that looks eroded:

```js
function landH(x, z) {
  const wx = x + fbm(x * 0.012, z * 0.012, 3) * 26;   // domain warp
  const wz = z + fbm(x * 0.012 + 41, z * 0.012 - 17, 3) * 26;
  let h = fbm(wx * 0.0075, wz * 0.0075, 5) * 34;      // broad landforms
  h += ridged(wx * 0.021, wz * 0.021, 3) * 9;         // ridge lines
  return h;
}
```

Keep the analytic function separate from the mesh. Grass, stones, fog and anything else you scatter must sample the same `landH`, or they will float and sink.

Ridge layers have to scale with distance. A ridge amplitude that reads well at 40 units is invisible at 600, so the far rings need theirs multiplied up or the horizon goes flat.

##### Colour by what the ground is doing, not by a texture

A tiled ground texture always announces itself. Compute a vertex colour from the terrain's own properties instead:

```js
const slope = 1 - normal.y;                      // steep = rock
const moist = smoothstep(-4, 6, -height);        // low = wet, green
const c = rock.clone()
  .lerp(grass, (1 - slope * 3.2) * (0.35 + moist * 0.65))
  .lerp(sand, Math.max(0, 0.5 - moist) * 0.6);
```

You get cliffs that go stony, hollows that go green and ridges that go pale, for free, with no UVs and no seams. Keep a very low-frequency noise on top so the colour does not band.

##### Grass: one ribbon, shaped entirely in the vertex shader

100k blades is a single `InstancedMesh` of a five-segment ribbon. Every bend, lean, taper and gust happens in the vertex shader, so the wind costs nothing on the CPU:

```js
const geo = new THREE.BufferGeometry();          // 11 verts: a strip + a tip
const mesh = new THREE.InstancedMesh(geo, mat, 104000);
mat.onBeforeCompile = sh => {
  Object.assign(sh.uniforms, grassUni);
  sh.vertexShader = `
    uniform float uTime, uWindAmp; uniform vec2 uWind;
    attribute vec4 aParams;                      // height, phase, tint, lean
    varying float vT; varying float vTint;
  ` + sh.vertexShader.replace('#include <begin_vertex>', `
    float gT = position.y;                       // 0 at root, 1 at tip
    float gBend = uRestBend + sin(uTime * 1.7 + aParams.y) * uWindAmp;
    vec2  gRib  = ... ;                          // sweep the blade along an arc
    vec3 transformed = vec3(gRib.x, gT * aParams.x, gRib.y);
  `);
};
mat.customProgramCacheKey = () => 'grass';       // or every instance recompiles
```

Anchor the field to the camera. Keep a fixed grid of blades around the viewer and move the *grid*, snapping to cell size, rather than growing the field outward. The player never reaches the edge and you never pay for grass behind them.

**Do not hard-code the blade colour in the fragment shader and then expect the material colour to change it.** `diffuseColor.rgb *= mix(base, tip, t)` multiplies whatever the material gave you, so a white material times a green constant is still green. If anything — settled snow, a season, a night palette — has to recolour the grass, that mix needs its own uniform. This costs an hour to find because every debug print says the material is white.

##### Stones from the same height function

Scatter with rejection sampling against slope, then `setMatrixAt` on an `InstancedMesh`. Weld the icosphere and scale it flat so they read as embedded rather than dropped:

```js
geo.scale(1, 0.62, 1); geo.translate(0, 0.3, 0);   // sunk, not resting
```

A few thousand at three or four sizes is enough. They matter most near the subject, where they give the eye something to measure scale against.

##### Sky: six stops on an 8×512 canvas

Paint a vertical gradient into a tiny canvas and map it to a back-side sphere. Repainting it is so cheap you can do it every frame of a transition:

```js
const grd = ctx.createLinearGradient(0, 0, 0, 512);
[0, 0.30, 0.52, 0.68, 0.84, 1].forEach((s, i) => grd.addColorStop(s, cols[i]));
ctx.fillStyle = grd; ctx.fillRect(0, 0, 8, 512);
skyMat.map.needsUpdate = true;
```

Six stops is the number. Three gives you a CSS gradient; ten and you cannot tune it. Put the horizon stop slightly *below* the geometric horizon so the fog colour and the sky meet without a visible line.

##### Stars: confine them to the band the camera can reach

The mistake is scattering over the whole sphere. With a ~10° lens the frame sees about 0.5% of it, so 1,200 stars puts roughly six on screen and reads as a bug.

- Confine to the elevation band your camera clamp actually allows.
- Use three size classes with different point sizes so brightness varies.
- Scale `PointsMaterial.size` by `devicePixelRatio` or they vanish on retina.
- Additive blending, `sizeAttenuation: false`, `fog: false`, `depthWrite: false`.

Around 39,000 points across three classes gives a sky that reads as stars rather than as noise. It costs one draw call each.

##### Time of day is interpolation, not a switch

Store each time of day as a full state — sun position and colour, hemisphere, ambient, fill, rim, fog colour and range, ground, grass, six sky stops, shadow strength, star opacity — and lerp between two of them:

```js
function applyState(A, B, t) {
  key.position.setFromSpherical(lerpAngle(A.sun, B.sun, t));
  key.color.copy(A.sunC).clone().lerp(B.sunC, t);
  scene.fog.color.copy(A.fog).lerp(B.fog, t);
  for (let i = 0; i < 6; i++) CUR.sky[i].copy(A.sky[i]).lerp(B.sky[i], t);
  paintSky(CUR.sky);
}
```

When the user switches mid-transition, freeze the *current interpolated* state as the new `A` rather than snapping to the last preset. Otherwise every impatient click jumps.

Keep weather as a multiplier layered on top of this, never as more presets. Four times of day × four weathers is four states and four modifiers, not sixteen.

##### What to check before you call it done

- Orbit below the horizon once. If you can see the sky through the ground, your winding is inverted.
- Look at the far ring. If the terrain is flat out there, your ridge amplitude is not scaling with distance.
- Switch time of day mid-transition twice in a row. It should never jump.
- Check on a retina display. Stars and thin geometry are where DPR bugs show first.
- Watch the draw call count, not the triangle count. 1.3M triangles in 18 calls runs at 120fps; 200k triangles in 900 calls does not.


---

### threejs-towers
**Description:** Generate architecture procedurally in Three.js and film it assembling — a small geometry vocabulary that builds pagodas, castles, domes and spires from parameters instead of mesh files, hip roofs with flying eaves driven by a single profile function, and a clipping-plane build animation where everything below a rising line is finished work and scaffolding stands above it. Use for construction studies, architectural title sequences, procedural landmarks, or any hero object that should build itself rather than fade in.


#### Three.js Towers

Architecture is the one subject where procedural generation pays immediately: buildings are made of repeated, parameterised parts, and once you have the vocabulary a second style costs a parameter set rather than a model.

Stand it in `threejs-landscape` and weather it with `threejs-weather`.

##### Build the vocabulary before the building

Write ten small builders that all append into shared vertex/normal/UV/index arrays, then never write raw geometry again:

```txt
face(P, uv)                     quad with a computed normal
box(cx,cy,cz, sx,sy,sz, ry, uvScale, rz)
prism(y0,y1, R0,R1, uv, capTop, capBot)          square on plan
prismN(y0,y1, R0,R1, n, uv, capTop, capBot)      any n-gon
sweepPlan(plan, y0,y1, steps, profile)           an outline scaled up a curve
lathe(cx,cy,cz, y0,y1, profile, steps, seg)      surface of revolution
ring / arc                                        annulus on a face plane
fan(points, z, ry, cx, cy)                        filled polygon on a face
tube(points, r, sides)                            swept tube
```

That set covers a Japanese keep, a Chinese pagoda, an Ottoman dome, a Khmer prasat and a Vietnamese tháp. Each style becomes one assembly function plus a table of levels.

Merge by material, not by part. Six buildings drawn in 11–18 draw calls is the difference between 120fps and 30.

**Winding is the bug you will hit most.** A prism whose side faces are wound inward gets back-face culled and you find yourself looking at the inside of the far wall. Get one prism right, then copy its vertex order everywhere. When a surface goes missing, suspect winding before you suspect anything else.

##### Roofs are a function of position along the eave

The whole character of an East Asian roof — flat near the ridge, steepening, then curling up at the corners — comes from one function that maps *(panel, position across, position down)* to a point:

```js
function roofPoint(o, p, u, t) {
  const tc = Math.min(1, t);
  const g = 1 - Math.pow(1 - tc, o.pow);              // the sag of the slope
  const corner = Math.pow(Math.abs(u), 2.0);          // 0 mid-eave, 1 at hips
  const flare = 1 + o.flare * corner * Math.pow(tc, 3.2);
  const y = o.yT - (o.yT - o.yE) * g
          + o.lift * corner * Math.pow(tc, 2.6);      // corners lift
  return [ /* lerp inner edge → outer edge × flare */ ];
}
```

Six numbers give you every roof in the set: `lift`, `tip`, `flare`, `pow`, `trunc`, `ridge`. `trunc` is the one that is easy to miss — it lets a lower roof die cleanly behind the wall above it instead of poking through.

**`Math.pow(negative, 2.35)` is NaN.** Tiles that overshoot the eave push `t` past 1, and the whole roof silently disappears. Clamp `tc = Math.min(1, t)` and handle the overshoot as a separate linear term.

##### Non-square plans

`prismN` handles octagons and sixteen-sided drums. For anything with re-entrant corners — a Khmer prasat is a square pushed out on each axis and stepped back twice before the corner — build the outline once and sweep it:

```js
const oct = [[1+P,0],[1+P,0.30],[1.0,0.30],[1.0,0.45],[0.90,0.45], ... ];
const half = oct.concat(oct.slice(0,-1).reverse().map(q => [q[1], q[0]]));
// mirror across the diagonal, then rotate four times
```

Then every storey is the same outline at a smaller scale, and the silhouette is coherent for free.

**Deck the ledges.** Where a storey steps back onto the one above, the gap between the two outlines is open. Fill it with a flat annulus on the plan or the tower reads as a stack of floating shelves with daylight between them.

##### Size detail to the surface it sits on

The most common modelling mistake is not the geometry, it is the proportion. A doorway sized for a face that turns out to be a third as wide spills onto the returns and reads as noise. Measure the face first, then size the door, the colonnettes and the pediment as fractions of it — and check that the pediment finishes *under* the cornice rather than through it.

##### The build animation is one clipping plane

Everything exists from the first frame. A plane facing down travels up, and every structural material clips against it:

```js
renderer.localClippingEnabled = true;
const CLIP = new THREE.Plane(new THREE.Vector3(0, -1, 0), 0);
['stone','plaster','tile','timber', ...].forEach(k => {
  MAT[k].clippingPlanes = [CLIP];
  MAT[k].clipShadows = true;                     // or the shadow builds early
});
CLIP.constant = heightAt(t);
```

A clipped shell is hollow, so add a cap mesh at the plane's height, scaled to the footprint. That is what turns a see-through section into what reads as a solid course of masonry.

**The cap has to match the plan it is capping.** A square cap dropped into an octagonal tower leaves four wedges open to the sky. Let each style declare the plan of its own section — four sides through a hall, eight through a drum, sixteen through a dome — and rebuild the cap geometry as the plane passes from one into the next:

```js
caps: [[0, 4.74, 2.56], [4.74, 5.42, 2.02, 8], [5.42, 6.46, 1.86, 16]]
//      y0    y1   radius  sides
```

For interiors, a capped inner volume on a `DoubleSide` dark material reads as solid stone from any angle, and costs almost nothing.

##### Scaffolding is the exception to the plane

It ignores the clip, so it always stands one step ahead of the finished work. That single relationship is what makes the animation read as construction rather than as a wipe.

**`BoxGeometry` gives every face UVs of 0..1 regardless of size.** A three-metre pole and a fifteen-centimetre brace therefore get the same grain, and both read as plastic. Rewrite the UVs in world units before upload:

```js
const dims = [[sz,sy],[sz,sy],[sx,sz],[sx,sz],[sx,sy],[sx,sy]];
for (let f = 0; f < 6; f++) {
  const du = dims[f][0], dv = dims[f][1], swap = dv > du;
  for (let i = 0; i < 4; i++) { /* scale by real size, offset randomly */ }
}
```

Grow each tier in with a short eased scale — verticals scale in Y, horizontals in X — and let it fall away just before the next stage lands.

##### Stages carry the timeline

Give each style a list of `[local caption, ENGLISH, target height]` and ease the plane between targets. The caption names what is happening, which is most of what makes a construction study legible:

```js
stages: [['準備','READY',0.00], ['石垣普請','STONEWORK',3.36],
         ['柱梁組立','TIMBER',6.24], ['白壁塗籠','PLASTER',8.80], ...]
```

Fire a one-shot sound on each stage change and a bell on the last. Keep the whole build short — four to five seconds — and put a large percentage somewhere quiet in the frame. People will rebuild it repeatedly if it is fast.

##### Emissive light leaks

If you light windows at night with an emissive material, that glow escapes through every opening you did not deck: under eaves, through truncated roofs, out of hollow storeys. Deck the truncated roofs and split enclosed volumes onto a non-emissive material. The symptom is a building that glows along its silhouette like a lantern.

##### What to check before you call it done

- Orbit a full turn at ground level. Missing walls are inverted winding; long bars flying out of faces are a rotation sign error on face-mounted boxes.
- Scrub the timeline slowly through every stage. The cap should stay inside the walls at every height, and never poke out at the corners.
- Look at the roof from directly above once. Overshooting tiles and NaN panels only show from there.
- Switch styles ten times. If memory climbs, you are not disposing the previous group's geometries.
- Count draw calls per style. If one style is triple the others, a material is not shared.


---

### threejs-weather
**Description:** Put weather into a Three.js scene that reads as weather — rain anchored inside the frustum, a storm that is the rain leaned on rather than a second system, lightning on its own light with thunder scheduled by distance, snow that blows up into blizzards and keeps settling until the ground goes white, wet ground with puddles and splashes, and looping ambience that has no seam. Use for scene atmosphere, seasonal states, hero backdrops, or any world where clear/rain/storm/snow needs to be a control the viewer can turn.


#### Three.js Weather

Weather fails in two ways: the particles miss the camera entirely, or every state is a separate system that shares nothing. Both are avoidable.

Pairs with `threejs-landscape` for the ground it falls on, and `threejs-towers` for something to fall against.

##### Anchor the volume in the frustum

The first version of any rain system puts a world-sized box of particles around the origin and looks empty. With a long lens the camera sees a narrow cone, so almost every drop is off-camera.

Build a small volume and carry it in front of the camera, facing the way the camera faces:

```js
const WX_W = 17, WX_D = 50, WX_TOP = 40;         // narrow, deep, tall
function anchor(o) {
  const fx = -Math.sin(camAz), fz = -Math.cos(camAz);
  o.position.set(cam.position.x + fx * 46, 0, cam.position.z + fz * 46);
  o.rotation.y = camAz;
}
```

Set `frustumCulled = false` on it — you are moving it every frame and the bounding sphere will fight you.

##### Float32BufferAttribute copies your array

This one costs an afternoon. The attribute takes a copy of whatever you hand it, so the array you kept a reference to is not the one the GPU reads:

```js
const attr = new THREE.Float32BufferAttribute(pos, 3);
attr.setUsage(THREE.DynamicDrawUsage);
geo.setAttribute('position', attr);
return { pts, pos: attr.array, n };              // keep the attribute's array
```

Symptom: everything is correct, nothing moves, no error anywhere.

##### Density is a draw range, not a new buffer

Allocate the worst case once — a full storm, a full blizzard — and thin it by drawing less:

```js
RAIN.geo.setDrawRange(0, Math.round(RAIN.n * density));
```

A storm then costs no more memory than drizzle; it just stops hiding most of the drops. Reallocating buffers when weather changes causes a hitch exactly when the viewer is watching.

##### A storm is the rain leaned on

Do not write a second particle system. Take the rain state and push every dial:

| | rain | storm |
|---|---|---|
| drops drawn | 60% of pool | 100% |
| fall speed | ×1.0 | ×1.42 |
| slant | 2.4 | scales with speed² |
| sun | 30% | 14% |
| fog far | ×0.52 | ×0.38 |

Slant should grow faster than speed — `slant = base * v * v` — because that is what sells wind rather than "rain, but quicker".

##### Lightning is its own light

Do not modify the time-of-day state to flash. Add a light nobody else touches, so a strike can flash over whatever the sky happens to be doing:

```js
const bolt = new THREE.DirectionalLight(0xe8eeff, 0);
```

One strike is several flashes — a leader and two or three return strokes — each an exponential decay:

```js
function strike() {
  const near = Math.random();                    // 0 distant … 1 close
  const s = 0.42 + near * 0.58;
  pulses = [{ t: 0, a: s }];
  let tt = 0;
  for (let i = 0, n = 1 + (Math.random() * 2.6 | 0); i < n; i++) {
    tt += 0.05 + Math.random() * 0.14;
    pulses.push({ t: tt, a: s * (0.30 + Math.random() * 0.65) });
  }
  setTimeout(() => sfx(near > 0.5 ? 'thunder_near' : 'thunder_far',
                      { gain: 0.30 + near * 0.60 }),
             (0.32 + (1 - near) * 2.7) * 1000);  // sound arrives late
}
function step(dt) {
  let v = 0;
  for (const p of pulses) if (age >= p.t) v += p.a * Math.exp(-(age - p.t) / 0.085);
  bolt.intensity = v * 3.2;
  skyMat.color.setScalar(1 + v * 0.80);          // multiplies the sky map
  flashEl.style.opacity = (v * 0.15).toFixed(3);
}
```

Two details do most of the work. **Thunder is delayed by distance and quieter the longer it takes** — that single correlation is what makes a strike feel far away. And the **DOM flash belongs under the type, not over it**: a full-screen white overlay above your typography washes the page out, so put it directly above the canvas and keep it under about 0.18 opacity.

Reposition the light on every strike. A flash that always comes from the same side stops reading after the second one.

##### A blizzard is a slow envelope, not a state

Snow does not fall at one rate forever. Run a cycle — calm, build, blow, ease — and modulate the snow state with it:

```js
const BLIZ = [12, 6, 15, 8];                     // seconds
function blizzardAt(t) {
  let u = t % TOTAL; if (u < 0) u += TOTAL;
  if (u < BLIZ[0]) return 0;
  ...                                            // smoothstep in, hold, out
}
```

During the blow, open the flake pool, thicken the flakes, drive them sideways and pull the fog in. **Reset the phase clock to zero when you leave the snow state**, or arriving in snow drops you into the middle of a whiteout — a negative start offset wraps into the wrong phase and looks like a bug you cannot find.

##### Falling snow and settled snow are two variables

The one people forget. Track what has already landed on its own slow timer, rising while snow falls and melting back when the weather turns:

```js
snowPack += (target - snowPack) * (target > snowPack ? dt / 24 : dt / 13);
```

Then let it keep whitening the ground, the stones and the grass for as long as it falls. Arriving in snow and standing in it for a minute should not look the same.

If the surface colour is mixed inside a shader — instanced grass usually is — the material colour cannot reach it. Give that mix its own uniform, and let snow lie on the tips first and work down:

```glsl
gBase = mix(gBase, vec3(0.60, 0.65, 0.72), uSnow * 0.86);
gTip  = mix(gTip,  vec3(0.90, 0.94, 1.00), uSnow);
```

##### Re-light only when the slow values move

Relighting the scene is not free, and blizzard strength and snow depth drift continuously. Gate it:

```js
const look = blizK + snowPack;
if (Math.abs(look - lastLook) > 0.006) { lastLook = look; refreshLook(); }
```

That fires a few times a second instead of sixty, and nothing on screen can tell.

##### Wet ground

Three cheap things, in order of payoff: drop roughness and add a little metalness so the ground catches the sky; add flat translucent puddle decals in the hollows; then instance a splash ring sprite with a short life, spawned in proportion to rain intensity. The splashes are what make it read as *falling* rain rather than a rain texture.

##### Ambience that loops with no seam

Generated audio never loops cleanly. Fold the tail back over the head with an equal-power cross-fade and throw the overlap away — the clip then ends where it starts:

```python
for i in range(f):
    t = i / f
    out[i] = a[i] * sin(t * pi / 2) + a[n - f + i] * cos(t * pi / 2)
```

Fading the clip in and out instead means it dips to silence every lap, which everyone hears and nobody mentions.

Give weather its own gain bus, separate from music, and run the blizzard as a **second layer swelling over the base bed** rather than a cross-fade to a different clip — a hard swap in the middle of a storm is obvious.

##### What to check before you call it done

- Watch a single drop from spawn to ground. If you cannot find one, your volume is outside the frustum.
- Leave it in snow for two minutes. The ground should be visibly whiter at the end, and you should have seen at least one blizzard arrive and pass.
- Enter snow from clear five times. It must start calm every time.
- Stand in a storm for a minute. Strikes should come from different sides, and thunder should never land on the flash.
- Profile with the storm running. Particles are cheap; the relight you forgot to gate is not.


---

### webgl-3d-object
**Description:** Create a real 3D WebGL object with geometric mesh depth, physically based material, directional and ambient lighting, perspective camera, subtle rotation, and floating motion. Use when a page needs a faceted 3D hero object or product-like visual with real lighting instead of CSS transform tricks.


#### WebGL 3D Object

##### Use When
- A hero, feature block, or product moment needs one strong 3D object.
- The visual should show real geometry, lighting, highlights, and edges.
- A faceted mesh should float or rotate subtly inside a web layout.
- CSS transforms, SVG illusions, or flat gradients are not enough.

##### Rules
1. Use real 3D geometry: `IcosahedronGeometry`, `DodecahedronGeometry`, `BoxGeometry`, custom `BufferGeometry`, or a glTF mesh.
2. Use a perspective camera so the object has depth and scale.
3. Use PBR material: `MeshStandardMaterial` or `MeshPhysicalMaterial`.
4. Tune `metalness`, `roughness`, and `emissive` to match the brand mood.
5. Light the object with at least one directional light plus ambient or hemisphere fill.
6. Animate transforms only: subtle rotation, bobbing, or parallax.
7. Handle resize and dispose geometry/material/renderer on teardown.

##### HTML And CSS

```html
<div class="webgl-object-shell">
  <canvas class="webgl-object-canvas" data-webgl-3d-object></canvas>
</div>
```

```css
.webgl-object-shell {
  position: relative;
  width: min(100%, 720px);
  aspect-ratio: 1 / 1;
}

.webgl-object-canvas {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  display: block;
}
```

##### Three.js Object Recipe

```js
import * as THREE from "three";

function initWebGL3DObject(canvas, options = {}) {
  if (!canvas) return () => {};

  const renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: true,
    alpha: true,
  });
  renderer.setClearColor(0x000000, 0);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, options.maxDpr || 1.75));
  renderer.outputColorSpace = THREE.SRGBColorSpace;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = options.exposure || 1.05;
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100);
  camera.position.set(0, 0.15, 5.2);

  const geometry = new THREE.IcosahedronGeometry(options.radius || 1.35, options.detail || 1);
  const material = new THREE.MeshStandardMaterial({
    color: options.color || 0x8aa4ff,
    metalness: options.metalness ?? 0.48,
    roughness: options.roughness ?? 0.34,
    emissive: options.emissive || 0x101833,
    emissiveIntensity: options.emissiveIntensity ?? 0.22,
    flatShading: true,
  });

  const object = new THREE.Mesh(geometry, material);
  object.castShadow = true;
  object.receiveShadow = true;
  scene.add(object);

  const ambient = new THREE.AmbientLight(0xffffff, 0.38);
  scene.add(ambient);

  const key = new THREE.DirectionalLight(0xffffff, 2.15);
  key.position.set(3.4, 4.2, 4.8);
  key.castShadow = true;
  key.shadow.mapSize.set(1024, 1024);
  scene.add(key);

  const rim = new THREE.DirectionalLight(options.rimColor || 0x7dd3fc, 0.82);
  rim.position.set(-4.2, 1.2, -2.8);
  scene.add(rim);

  const shadowPlane = new THREE.Mesh(
    new THREE.PlaneGeometry(5.2, 5.2),
    new THREE.ShadowMaterial({ opacity: 0.18 })
  );
  shadowPlane.position.set(0, -1.65, 0);
  shadowPlane.rotation.x = -Math.PI / 2;
  shadowPlane.receiveShadow = true;
  scene.add(shadowPlane);

  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let rafId = 0;

  function resize() {
    const width = Math.max(1, canvas.clientWidth);
    const height = Math.max(1, canvas.clientHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, options.maxDpr || 1.75));
    renderer.setSize(width, height, false);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  }

  function render(time = 0) {
    const t = time * 0.001;
    object.rotation.x = -0.16 + Math.sin(t * 0.45) * 0.06;
    object.rotation.y = t * 0.28;
    object.rotation.z = Math.sin(t * 0.32) * 0.08;
    object.position.y = reduceMotion ? 0 : Math.sin(t * 0.8) * 0.08;

    renderer.render(scene, camera);
    if (!reduceMotion) rafId = requestAnimationFrame(render);
  }

  function handleResize() {
    cancelAnimationFrame(rafId);
    resize();
    render();
  }

  resize();
  render();
  window.addEventListener("resize", handleResize);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
    geometry.dispose();
    material.dispose();
    shadowPlane.geometry.dispose();
    shadowPlane.material.dispose();
    renderer.dispose();
  };
}

const cleanupObject = initWebGL3DObject(
  document.querySelector("[data-webgl-3d-object]"),
  {
    color: 0x8aa4ff,
    rimColor: 0x7dd3fc,
    metalness: 0.48,
    roughness: 0.34,
    emissive: 0x101833,
  }
);
```

##### Material Defaults
- Premium metal: `metalness: 0.45-0.7`, `roughness: 0.25-0.45`.
- Soft ceramic: `metalness: 0.0-0.15`, `roughness: 0.38-0.62`.
- Glow-tinted tech object: low `emissive` with `emissiveIntensity: 0.12-0.35`.
- Faceted object: set `flatShading: true`; smooth product object: set it to `false`.

##### Lighting Defaults
- Key light: directional, high front-side angle, strongest source.
- Ambient fill: low intensity so shadows stay visible.
- Rim light: brand-tinted or cool light from behind to reveal edges.
- Shadows: enable only when the object needs grounded depth; keep map size moderate.

##### Motion Defaults
- Rotation: slow, continuous, and secondary to the page content.
- Floating: `0.04` to `0.12` units on Y.
- Reduced motion: render a still frame or only allow direct interaction.
- Avoid camera movement unless the object is the main interaction.

##### Avoid
- CSS 3D transforms pretending to be WebGL.
- Unlit materials when the ask is real lighting and depth.
- Flat planes with gradients instead of actual geometry.
- Strong bloom or particles that hide the form.
- High DPR, huge shadow maps, or too many lights on mobile.
- Letting the object compete with foreground copy or CTAs.

##### Quick Checks
- The object has visible form, edges, highlights, and shadows.
- The material uses `metalness`, `roughness`, and optional `emissive`.
- Directional and ambient lights are both present.
- The camera is perspective, not orthographic by accident.
- Resize does not stretch the object.
- Geometry, material, event listeners, RAF, and renderer are cleaned up.


---

### webgl-landing-steering
**Description:** Use when creating or refining WebGL-heavy landing pages and you need to steer toward a specific visual outcome (premium, technical, playful, cinematic) while balancing conversion clarity, performance, and implementation complexity.


#### WebGL Landing Steering Skill

##### Use this skill to steer outcomes
Map landing-page goal to WebGL direction before writing code.

###### 1) Define the page intent
Identify the primary conversion and brand signal:
- Premium / luxury / minimal confidence
- Technical / infrastructure / data authority
- Playful / consumer / social energy
- Cinematic / launch / storytelling impact

Also capture:
- Device mix (desktop-heavy vs mobile-heavy)
- Motion tolerance (`prefers-reduced-motion` policy)
- Production constraints (deadline, team skill, maintenance budget)

###### 2) Choose the WebGL lane
Pick one dominant lane; avoid mixing 3-4 heavy effects in the hero.

####### Lane A: Subtle depth field (high conversion safety)
Use for: SaaS, productivity, B2B tools where readability wins.
- Visuals: soft gradient meshes, slow parallax planes, light bloom
- Motion: low amplitude, always secondary to copy
- Stack: Three.js plane shaders or lightweight shader canvas
- Rule: hero text contrast and CTA prominence first

####### Lane B: Data/particle intelligence (technical credibility)
Use for: AI, infra, analytics, developer products.
- Visuals: particle flows, node networks, vector fields, wireframes
- Motion: purposeful directional flow toward CTA area
- Stack: Three.js + custom shader/points, optionally GPGPU for dense fields
- Rule: communicate "system behavior," not random sparkles

####### Lane C: Object-centric 3D product moment (feature clarity)
Use for: hardware, apps with strong product visuals, launches.
- Visuals: central GLTF model, controlled camera orbit, material highlights
- Motion: interaction-driven or timeline-based reveal
- Stack: Three.js + GLTF/DRACO/KTX2 pipeline
- Rule: one hero object, short loop, fast first meaningful paint fallback

####### Lane D: Immersive cinematic scene (brand campaign)
Use for: campaign pages where wow factor is the main KPI.
- Visuals: volumetrics, heavy postprocessing, dense scene composition
- Motion: choreographed sequence with scroll chapters
- Stack: Three.js + postprocessing + optional GSAP ScrollTrigger
- Rule: provide a static/mobile fallback and strict performance gates

###### 3) Steering matrix by landing page type
- Waitlist / pre-launch: Lane A or B. Keep copy legible and quick to load.
- Product feature page: Lane A or C. Demonstrate product truth, not abstract noise.
- Pricing / high-intent page: Mostly Lane A. Keep WebGL decorative only.
- Enterprise trust page: Lane B with restrained palette and low noise.
- Consumer app growth page: Lane B with playful palette, but cap CPU/GPU load.
- Campaign microsite: Lane C or D with explicit fallback for lower-end devices.

###### 4) Quality gates before shipping
Pass these gates before adding more visual complexity:

1. Message gate:
- Hero headline + CTA readable in under 3 seconds.
- WebGL never blocks understanding of offer.

2. Performance gate:
- Cap pixel ratio: `Math.min(devicePixelRatio, 1.5-2)`.
- Target stable frame time on common mobile devices.
- Lazy-load heavy assets; show immediate non-WebGL poster/fallback.

3. Accessibility gate:
- Respect `prefers-reduced-motion` (still frame or low-motion mode).
- Maintain color contrast over animated backgrounds.

4. Reliability gate:
- Handle context loss and resize.
- Dispose geometries/materials/textures in SPA route changes.

###### 5) Implementation strategy by risk
- Low risk (fastest): CSS + canvas illusion, minimal shaders
- Medium risk: Three.js scene with 1-2 meshes, lightweight post FX
- High risk: multi-pass shaders, dense particles, advanced postprocessing

Default to low/medium risk for conversion pages unless user explicitly asks for campaign-grade immersion.

###### 6) Prompting template for Codex-style execution
Use this prompt pattern when asked to build a WebGL landing hero:

"Build a [lane] WebGL hero for a [page type] with [brand adjectives].
Primary goal: [conversion].
Constraints: [device mix], [performance budget], [reduced motion policy].
Implement fallback first, then enhance with WebGL.
Keep hero copy clarity as priority over visual complexity."

###### 7) Common failure patterns and corrections
- Failure: "Looks cool but conversion dropped."
  - Fix: reduce motion amplitude, darken/soften background, raise CTA contrast.
- Failure: "Mobile stutters."
  - Fix: reduce particle count, lower DPR cap, remove expensive postprocessing.
- Failure: "Visual style feels generic."
  - Fix: pick one signature motif aligned to brand (grid, wave, orbit, shards).
- Failure: "Team cannot maintain shader complexity."
  - Fix: simplify to modular Three.js scene with documented parameters.

##### Output format when applying this skill
Return:
1. Recommended lane and why
2. Visual spec (palette, motion behavior, composition)
3. Technical stack and complexity tier
4. Fallback behavior
5. Performance + accessibility checklist
6. Build order (MVP first, enhancement second)


---

### webgl-laser
**Description:** Create a fixed full-screen WebGL laser background effect with a thin white-hot vertical core, restrained brand-colored halo, and soft smoky fog around the beam. Use only for laser background effects, not full page layout, copy, generic hero scenes, particles, or unrelated motion systems.


#### WebGL Laser

##### Scope
- Apply only to the laser background effect.
- Use a fixed full-screen canvas behind the DOM.
- Set `pointer-events: none` on the canvas.
- Keep page content in a higher stacking context.
- Match the halo and smoke to the page's primary or strongest accent color.

##### Visual Target
- Thin vertical beam: crisp white-hot inner core, narrow colored halo.
- Atmospheric smoke: soft cloudy breakup concentrated around the beam.
- Dark cinematic field: restrained, brand-colored, and readable behind content.
- Slow pulse: glow breathes gently; no aggressive flicker or color cycling.
- Light blade feel: narrow and precise, never a thick neon pillar.

##### Layering

```html
<canvas class="laser-canvas" data-webgl-laser></canvas>
<main class="page-content">
  ...
</main>
```

```css
.laser-canvas {
  position: fixed;
  inset: 0;
  z-index: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
}

.page-content {
  position: relative;
  z-index: 1;
}
```

##### Brand Color
Use the product accent as the source color. The shader keeps the core near white and derives the halo/smoke from this color.

```js
function hexToRgb01(hex) {
  const clean = hex.replace("#", "").trim();
  const value = clean.length === 3
    ? clean.split("").map((char) => char + char).join("")
    : clean;

  return [
    parseInt(value.slice(0, 2), 16) / 255,
    parseInt(value.slice(2, 4), 16) / 255,
    parseInt(value.slice(4, 6), 16) / 255,
  ];
}

const accent = getComputedStyle(document.documentElement)
  .getPropertyValue("--brand-accent")
  .trim() || "#ff4d8d";
```

##### Raw WebGL Setup
Prefer raw WebGL with a full-screen quad unless the active file already uses another renderer.

```js
const laserVertexShader = `
attribute vec2 a_position;
varying vec2 v_uv;

void main() {
  v_uv = a_position * 0.5 + 0.5;
  gl_Position = vec4(a_position, 0.0, 1.0);
}
`;

const laserFragmentShader = `
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec3 u_color;
uniform float u_xOffset;
uniform float u_coreWidth;
uniform float u_glowWidth;
uniform float u_smokeDensity;

varying vec2 v_uv;

float hash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;

  for (int i = 0; i < 5; i++) {
    value += amplitude * noise(p);
    p *= 2.02;
    amplitude *= 0.5;
  }

  return value;
}

void main() {
  vec2 aspect = vec2(u_resolution.x / u_resolution.y, 1.0);
  vec2 p = (v_uv - 0.5) * aspect;
  float x = p.x - u_xOffset;
  float distanceToBeam = abs(x);

  float core = exp(-pow(distanceToBeam / u_coreWidth, 2.0));
  float glow = exp(-pow(distanceToBeam / u_glowWidth, 1.45));
  float scatter = exp(-pow(distanceToBeam / (u_glowWidth * 5.5), 1.25));
  float pulse = 0.9 + 0.1 * sin(u_time * 1.15);

  vec2 fogUv = p * 3.1 + vec2(0.0, -u_time * 0.035);
  fogUv.x += sin(p.y * 3.5 + u_time * 0.11) * 0.14;
  float fogBase = fbm(fogUv);
  float fogFine = fbm(p * 8.0 + vec2(sin(u_time * 0.07) * 0.35, u_time * 0.05));
  float fog = smoothstep(0.30, 0.86, fogBase * 0.72 + fogFine * 0.28);
  float smoke = fog * scatter * u_smokeDensity;

  vec3 brand = clamp(u_color, 0.0, 1.0);
  vec3 haloColor = mix(brand, vec3(1.0), 0.16);
  vec3 smokeColor = mix(brand, vec3(0.55), 0.28) * 0.55;
  vec3 hotCore = vec3(1.0, 0.96, 0.90);

  vec3 color = vec3(0.006, 0.007, 0.010);
  color += smokeColor * smoke;
  color += haloColor * glow * 0.46 * pulse;
  color += hotCore * core * 1.35;

  float vignette = smoothstep(1.25, 0.18, length(p));
  color *= vignette;

  float alpha = clamp(smoke * 0.72 + glow * 0.68 + core, 0.0, 1.0);
  gl_FragColor = vec4(color, alpha);
}
`;
```

##### Initializer
Keep `u_resolution` synced on resize and animate through `u_time`.

```js
function createShader(gl, type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    throw new Error(gl.getShaderInfoLog(shader) || "Shader compile failed");
  }

  return shader;
}

function createProgram(gl, vertexSource, fragmentSource) {
  const program = gl.createProgram();
  gl.attachShader(program, createShader(gl, gl.VERTEX_SHADER, vertexSource));
  gl.attachShader(program, createShader(gl, gl.FRAGMENT_SHADER, fragmentSource));
  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    throw new Error(gl.getProgramInfoLog(program) || "Program link failed");
  }

  return program;
}

function initWebGLLaser(canvas, options = {}) {
  if (!canvas) return () => {};

  const gl = canvas.getContext("webgl", {
    alpha: true,
    antialias: false,
    premultipliedAlpha: false,
  });

  if (!gl) return () => {};

  const program = createProgram(gl, laserVertexShader, laserFragmentShader);
  const positionBuffer = gl.createBuffer();
  const positions = new Float32Array([
    -1, -1,
     1, -1,
    -1,  1,
    -1,  1,
     1, -1,
     1,  1,
  ]);

  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, positions, gl.STATIC_DRAW);
  gl.useProgram(program);

  const positionLocation = gl.getAttribLocation(program, "a_position");
  const uniforms = {
    resolution: gl.getUniformLocation(program, "u_resolution"),
    time: gl.getUniformLocation(program, "u_time"),
    color: gl.getUniformLocation(program, "u_color"),
    xOffset: gl.getUniformLocation(program, "u_xOffset"),
    coreWidth: gl.getUniformLocation(program, "u_coreWidth"),
    glowWidth: gl.getUniformLocation(program, "u_glowWidth"),
    smokeDensity: gl.getUniformLocation(program, "u_smokeDensity"),
  };

  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);
  gl.enable(gl.BLEND);
  gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

  const color = options.color || hexToRgb01(accent);
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let width = 1;
  let height = 1;
  let rafId = 0;

  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, options.maxDpr || 1.5);
    width = Math.max(1, window.innerWidth);
    height = Math.max(1, window.innerHeight);
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    gl.viewport(0, 0, canvas.width, canvas.height);
  }

  function render(time = 0) {
    gl.useProgram(program);
    gl.uniform2f(uniforms.resolution, canvas.width, canvas.height);
    gl.uniform1f(uniforms.time, time * 0.001);
    gl.uniform3f(uniforms.color, color[0], color[1], color[2]);
    gl.uniform1f(uniforms.xOffset, options.xOffset || 0.0);
    gl.uniform1f(uniforms.coreWidth, options.coreWidth || 0.0045);
    gl.uniform1f(uniforms.glowWidth, options.glowWidth || 0.035);
    gl.uniform1f(uniforms.smokeDensity, options.smokeDensity || 0.52);

    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 6);

    if (!reduceMotion) rafId = requestAnimationFrame(render);
  }

  function handleResize() {
    resize();
    render();
  }

  resize();
  render();
  window.addEventListener("resize", handleResize);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
    gl.deleteBuffer(positionBuffer);
    gl.deleteProgram(program);
  };
}

const cleanupLaser = initWebGLLaser(document.querySelector("[data-webgl-laser]"), {
  color: hexToRgb01(accent),
  xOffset: 0.0,
  coreWidth: 0.0045,
  glowWidth: 0.035,
  smokeDensity: 0.52,
  maxDpr: 1.5,
});
```

##### Tuning Knobs
- Beam position: adjust `xOffset`; keep it in aspect-correct centered UV space.
- Beam thickness: tune `coreWidth` separately from `glowWidth`; keep the core extremely thin.
- Color: derive `color` from the brand accent, then soften halo and smoke in shader.
- Smoke density: tune `smokeDensity`, FBM scale, drift speed, scatter width, and edge falloff.
- Performance: reduce FBM octaves or cap `maxDpr` before changing the visual structure.

##### Taste Rules
- The hottest beam core stays near white.
- The halo and fog use the design's primary or strongest accent color.
- Smoke blooms near the beam and dissipates outward.
- Pulse affects glow only; avoid rapid flicker.
- Content readability wins over bloom, haze, or cinematic drama.

##### Avoid
- Hardcoding blue when the design uses another primary color.
- Making the beam thick enough to read as a glowing bar.
- Generic full-screen fog that is not concentrated around the beam.
- Turning the effect into a Three.js scene, particle explosion, or multicolor neon background.
- Letting the canvas intercept pointer events.
- Dense fog or extreme bloom that washes out foreground UI.


---

### shaders-cursor-ripples
**Description:** Add cursor-following fluid WebGPU distortion over an existing image with the Shaders library's ImageTexture and CursorRipples components. Use when a hero, gallery, or media panel needs a water-ripple mouse effect; when replacing a drifting CSS spotlight or flashlight reveal; or when a prompt says to borrow only the shader interaction from a Shaders.com reference while preserving the current brand, image, copy, and layout.


#### Shaders Cursor Ripples

##### Core Contract

1. Preserve the existing page, content, and semantic image.
2. Install `shaders` and import from the active framework subpath.
3. Render the source image through one `Shader` canvas.
4. Place `CursorRipples` after `ImageTexture` so it post-processes that image.
5. Keep `toneMapping="aces"` on the root.
6. Let Shaders track the cursor. Remove custom spotlight coordinates, radial masks, duplicated reveal images, and pointer animation loops.
7. Keep one real image beneath the canvas as the accessible loading and WebGPU fallback.
8. Disable the shader for reduced motion and unsupported WebGPU.
9. Lazy-load the shader code so the library does not inflate the initial page bundle.

When the user asks for only the shader effect, do not copy a reference's ribbon, blob, glow, typography, layout, copy, colors, or identity. Do not substitute the Shaders `Water` component: `CursorRipples` is the interactive image-displacement effect.

##### Inspect Before Editing

- Find the real media wrapper, image URL, crop, overlays, z-index, and existing motion.
- Confirm the wrapper has a non-zero rendered width and height.
- Search for old reveal code such as `data-reveal-hover`, `mask-image: radial-gradient`, duplicated images, `requestAnimationFrame`, and manual pointer listeners.
- Preserve unrelated parallax or entrance motion unless it conflicts with the shader canvas.
- Check the installed `shaders` version and current framework API when the package may have changed.

##### Install

```bash
npm install shaders
```

Import from `shaders/react`, `shaders/vue`, `shaders/svelte`, or `shaders/solid`. For Vite projects, never add `shaders` to `optimizeDeps.exclude`; its CommonJS dependencies need Vite pre-bundling. No `optimizeDeps` entry is normally required.

Before a commercial release, verify the current Shaders license terms.

##### Required Composition

Keep the component order and values below:

```tsx
<Shader toneMapping="aces">
  <ImageTexture url={imageUrl} objectFit="cover" />
  <CursorRipples decay={7.3} radius={0.6} />
</Shader>
```

Use this as the baseline before tuning `intensity`, `chromaticSplit`, or `edges`. Do not add `SolidColor`, `Blob`, `Form3D`, `GaborNoise`, `Glow`, or another generator unless the user explicitly requests the reference's generated artwork.

For React, copy and adapt [assets/react/cursor-ripple-shader.tsx](assets/react/cursor-ripple-shader.tsx) and [assets/react/cursor-ripple-media.css](assets/react/cursor-ripple-media.css).

##### Client and Fallback Pattern

Mount the shader only after the browser confirms WebGPU and motion is allowed:

```tsx
const CursorRippleShader = lazy(() => import("./cursor-ripple-shader"));

const [shaderEnabled, setShaderEnabled] = useState(false);
const [shaderReady, setShaderReady] = useState(false);

useEffect(() => {
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

  const sync = () => {
    const enabled = "gpu" in navigator && !reduceMotion.matches;
    setShaderEnabled(enabled);
    if (!enabled) setShaderReady(false);
  };

  sync();
  reduceMotion.addEventListener("change", sync);
  return () => reduceMotion.removeEventListener("change", sync);
}, []);
```

Keep the semantic image in the wrapper, then overlay the lazy shader:

```tsx
<figure className="cursor-ripple-media">
  <img
    className="cursor-ripple-media__fallback"
    src={imageUrl}
    alt={meaningfulAlt}
    width={width}
    height={height}
  />

  {shaderEnabled ? (
    <Suspense fallback={null}>
      <CursorRippleShader
        imageUrl={imageUrl}
        ready={shaderReady}
        onReady={() => setShaderReady(true)}
      />
    </Suspense>
  ) : null}
</figure>
```

For Next.js, an `ssr: false` dynamic import is also valid. Do not hide the fallback until the shader calls `onReady`; a failed WebGPU initialization must leave the page legible and complete.

##### Layering Rules

- Give the media wrapper `position: relative`, a definite size, `overflow: hidden`, and `isolation: isolate`.
- Keep the fallback at z-index `0` and the canvas at z-index `1`.
- Fill the wrapper with `position: absolute; inset: 0; width: 100%; height: 100%`.
- Set the shader layer to `pointer-events: none`; Shaders listens globally and converts pointer coordinates using the canvas bounds.
- Mark the shader wrapper `aria-hidden="true"`; the fallback image owns the accessible name.
- Place copy, links, and controls above the canvas so the effect never intercepts interaction.
- Preserve the same crop between the fallback and `ImageTexture`. Use `objectFit="cover"` for full-bleed media.

##### Remove the Failed Spotlight Pattern

Delete the old implementation rather than leaving it hidden:

- second reveal image;
- radial `mask-image` and custom reveal variables;
- smoke or blur overlays tied to pointer position;
- component-local `requestAnimationFrame` pointer easing;
- `pointerenter`, `pointermove`, `pointerleave`, and resize bookkeeping created only for the flashlight;
- coarse-pointer rules that reference the retired reveal layers.

Keeping both systems causes coordinate drift, extra GPU work, and confusing fallbacks.

##### Performance and Motion

- Lazy-load the shader module behind the WebGPU check.
- Keep exactly one shader canvas for the media panel.
- Use the library's `onReady` callback for a short opacity handoff.
- Use `disableTelemetry` when telemetry is not required.
- Do not animate the canvas size; animate a stable parent if parallax is needed.
- Disable or unmount the shader under `prefers-reduced-motion: reduce`.
- Keep touch layouts usable with the static image; never put essential information inside the effect.

##### Verification

Run the project's lint, production build, rendered tests, and `git diff --check`. Then verify in a real browser:

1. Confirm exactly one `canvas[data-renderer="shaders"]` exists.
2. Confirm the shader reaches its ready class and the fallback image remains present.
3. Sweep the pointer across several points in the media. The distortion must follow that path without a detached circle.
4. Confirm links and controls remain clickable.
5. Confirm no console errors or warnings occur.
6. Confirm the static image remains when WebGPU is unavailable or reduced motion is enabled.
7. Confirm the old `data-reveal-hover` or radial-mask layer is absent.
8. Check mobile and desktop crops after the canvas initializes.

##### Failure Diagnosis

- **Canvas exists but is blank:** verify the wrapper has non-zero dimensions and the image URL is same-origin or CORS-readable.
- **Image renders but does not ripple:** keep `CursorRipples` after `ImageTexture`; it requires a child/input surface.
- **Ripple is offset:** remove manual pointer transforms and check whether a transformed ancestor changes the canvas bounds.
- **Page crashes during SSR:** move the shader into a client-only, lazy-loaded component.
- **Image flashes on load:** retain the fallback and fade the shader in only from `onReady`.
- **Initial bundle becomes large:** confirm the Shaders import lives only inside the lazy module.
- **Effect blocks buttons:** keep the canvas pointer-transparent and controls in a higher stacking layer.

##### Handoff

Report the affected media, Shaders package version, fallback behavior, reduced-motion behavior, build/test results, and live interaction verification. Distinguish a locally ready effect from a published deployment.


---

### cobejs
**Description:** Use when adding a lightweight interactive globe with cobe (canvas setup, markers, interaction, performance, integration with React/Next.js).


#### cobe.js — Lightweight WebGL Globe Skill

##### When to use
- A “spinning globe” / location markers in hero or about pages
- You want a small, focused globe lib (not full three.js)
- Decorative + interactive (markers, rotation) with minimal setup

##### Key APIs/patterns
- Core:
  - `import createGlobe from "cobe"`
  - `const globe = createGlobe(canvas, { ...options, onRender(state) { ... } })`
- Important options (common):
  - `devicePixelRatio`, `width`, `height`
  - `phi`, `theta` (rotation angles)
  - `scale`, `dark`, `diffuse`
  - `baseColor`, `markerColor`, `glowColor`
  - `markers: [{ location: [lat, lon], size, color? }]`
- Lifecycle:
  - `globe.toggle()` pauses RAF
  - `globe.destroy()` removes instance

##### Common pitfalls
- Canvas sizing mismatch
  - Set CSS size AND set canvas `width/height` scaled for DPR.
- Not updating on resize
  - Recompute width/height and recreate or update params.
- Too high DPR on mobile
  - Clamp DPR to 1–2.

##### Quick recipe: responsive globe with markers
```js
import createGlobe from "cobe";

const canvas = document.getElementById("cobe");
let phi = 0;

function setup() {
  const rect = canvas.getBoundingClientRect();
  const dpr = Math.min(window.devicePixelRatio, 2);
  canvas.width = Math.round(rect.width * dpr);
  canvas.height = Math.round(rect.height * dpr);

  const globe = createGlobe(canvas, {
    devicePixelRatio: dpr,
    width: canvas.width,
    height: canvas.height,
    phi: 0,
    theta: 0.2,
    dark: 0,
    diffuse: 1.2,
    scale: 1,
    mapSamples: 16000,
    mapBrightness: 6,
    baseColor: [0.2, 0.2, 0.25],
    glowColor: [1, 1, 1],
    markerColor: [0.8, 0.5, 1],
    markers: [{ location: [1.3521, 103.8198], size: 0.08 }],
    onRender: (state) => {
      state.phi = phi;
      phi += 0.01;
    },
  });

  return globe;
}

let globe = setup();
window.addEventListener("resize", () => {
  globe.destroy();
  globe = setup();
});
```

##### What to ask the user
- Globe size and placement (hero, section, card)?
- Marker locations + colors (brand-aligned)?
- Interaction needs (drag to rotate vs. ambient spin)?


---

### dither-background
**Description:** Create a dark monochrome procedural background with enlarged square pixels and visible Bayer-style ordered dithering. Use when a page needs an atmospheric near-black dither field, broad organic waves or cloud masses, and restrained gray-white highlights behind framed UI, hero content, or data overlays.


#### Dither Background

##### Use When
- A dark interface needs an atmospheric monochrome background layer.
- The visual should show enlarged square pixels and visible ordered dithering.
- The design calls for organic waves, cloud-like masses, or procedural depth without colorful gradients.
- The background should support framed UI, hero content, or data overlays.

##### Visual Target
- Near-black base with charcoal midtones, soft gray buildup, and occasional white highlights.
- Clearly visible square pixel cells, not tiny film grain.
- 4x4 Bayer-style dither pattern or equivalent ordered thresholding.
- Broad organic waves or cloud-like masses, not random TV noise.
- Vignetted edges so the brighter mass sits centrally or off-axis.

##### HTML And CSS

```html
<canvas class="dither-background" data-dither-background></canvas>
```

```css
.dither-background {
  position: fixed;
  inset: 0;
  z-index: 0;
  width: 100vw;
  height: 100vh;
  background: #030303;
  pointer-events: none;
}

.page-content {
  position: relative;
  z-index: 1;
}
```

##### Canvas Recipe
Use a real canvas when motion or procedural depth is needed.

```js
const BAYER_4X4 = [
   0,  8,  2, 10,
  12,  4, 14,  6,
   3, 11,  1,  9,
  15,  7, 13,  5,
].map((value) => (value + 0.5) / 16);

function smoothstep(edge0, edge1, value) {
  const t = Math.max(0, Math.min(1, (value - edge0) / (edge1 - edge0)));
  return t * t * (3 - 2 * t);
}

function noise2(x, y) {
  const value = Math.sin(x * 127.1 + y * 311.7) * 43758.5453123;
  return value - Math.floor(value);
}

function valueNoise(x, y) {
  const ix = Math.floor(x);
  const iy = Math.floor(y);
  const fx = x - ix;
  const fy = y - iy;
  const ux = fx * fx * (3 - 2 * fx);
  const uy = fy * fy * (3 - 2 * fy);

  const a = noise2(ix, iy);
  const b = noise2(ix + 1, iy);
  const c = noise2(ix, iy + 1);
  const d = noise2(ix + 1, iy + 1);
  return (
    a * (1 - ux) * (1 - uy) +
    b * ux * (1 - uy) +
    c * (1 - ux) * uy +
    d * ux * uy
  );
}

function fbm(x, y) {
  let value = 0;
  let amplitude = 0.5;
  let frequency = 1;

  for (let octave = 0; octave < 4; octave++) {
    value += valueNoise(x * frequency, y * frequency) * amplitude;
    frequency *= 2.02;
    amplitude *= 0.5;
  }

  return value;
}

function initDitherBackground(canvas, options = {}) {
  if (!canvas) return () => {};

  const ctx = canvas.getContext("2d", { alpha: false });
  if (!ctx) return () => {};

  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const cell = options.cellSize || 7;
  const maxDpr = options.maxDpr || 1.5;
  let width = 1;
  let height = 1;
  let cols = 1;
  let rows = 1;
  let rafId = 0;

  const palette = options.palette || [
    [3, 3, 3],
    [16, 16, 17],
    [34, 35, 37],
    [74, 75, 78],
    [168, 169, 171],
    [236, 236, 232],
  ];

  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, maxDpr);
    width = Math.max(1, window.innerWidth);
    height = Math.max(1, window.innerHeight);
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    cols = Math.ceil(width / cell);
    rows = Math.ceil(height / cell);
  }

  function sampleField(x, y, time) {
    const nx = (x / cols - 0.5) * 2;
    const ny = (y / rows - 0.5) * 2;
    const distance = Math.sqrt(nx * nx * 0.84 + ny * ny * 1.28);
    const vignette = 1 - smoothstep(0.18, 1.15, distance);
    const drift = reduceMotion ? 0 : time * 0.018;

    const wave =
      Math.sin(nx * 2.8 + ny * 1.2 + drift) * 0.18 +
      Math.sin(nx * -1.4 + ny * 3.8 - drift * 0.8) * 0.14;
    const cloud = fbm(nx * 1.35 + drift * 0.16, ny * 1.35 - drift * 0.08);
    const ridge = smoothstep(0.48, 0.92, cloud + wave);
    const offAxisMass = smoothstep(0.98, 0.18, Math.hypot(nx + 0.22, ny - 0.08));

    return Math.max(0, Math.min(1, ridge * vignette * 0.92 + offAxisMass * 0.18));
  }

  function render(time = 0) {
    const seconds = time * 0.001;
    ctx.fillStyle = "rgb(3,3,3)";
    ctx.fillRect(0, 0, width, height);

    for (let y = 0; y < rows; y++) {
      for (let x = 0; x < cols; x++) {
        const threshold = BAYER_4X4[(y % 4) * 4 + (x % 4)];
        const brightness = sampleField(x, y, seconds);
        const stepped = Math.floor(Math.max(0, Math.min(0.999, brightness + threshold * 0.18)) * palette.length);
        const color = palette[Math.min(palette.length - 1, stepped)];
        ctx.fillStyle = `rgb(${color[0]},${color[1]},${color[2]})`;
        ctx.fillRect(x * cell, y * cell, cell, cell);
      }
    }

    if (!reduceMotion) rafId = requestAnimationFrame(render);
  }

  function handleResize() {
    cancelAnimationFrame(rafId);
    resize();
    render();
  }

  resize();
  render();
  window.addEventListener("resize", handleResize);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
  };
}

const cleanupDither = initDitherBackground(
  document.querySelector("[data-dither-background]"),
  {
    cellSize: 7,
    maxDpr: 1.5,
  }
);
```

##### Tuning Knobs
- Cell size: `5px-10px`; larger cells make the Bayer matrix more legible.
- Palette: near-black, charcoal, soft gray, rare white highlights only.
- Shape: tune `wave`, `cloud`, `ridge`, and `offAxisMass` to create broad masses.
- Vignette: increase edge falloff when foreground readability needs more quiet.
- Motion: keep drift slow; use low time multipliers and avoid flicker.
- Performance: increase `cellSize` or cap `maxDpr` before simplifying the field.

##### Composition Notes
- Put the canvas behind the interface with `pointer-events: none`.
- Use it as atmosphere behind framed UI, hero copy, or data overlays.
- Keep foreground contrast controlled and typography clean.
- Let one main bright mass define the composition; avoid even full-screen brightness.

##### Avoid
- Rainbow gradients, colorful noise, or soft blurry blobs without dither structure.
- Tiny grain or static-like speckle where the square matrix disappears.
- Bright full-screen white noise that competes with foreground type.
- Random per-frame noise that flickers instead of drifting.
- Covering the entire viewport with equally bright cells.

##### Quick Checks
- The square Bayer pattern is visible from normal viewing distance.
- The field forms broad organic waves or cloud masses.
- The palette stays monochrome and restrained.
- Edges recede into near-black.
- Foreground UI remains readable without heavy overlays.


---

### dither-laser-dark-mode
**Description:** "Create a dark premium design system that combines near-black surfaces, subtle ordered-dither texture, and a thin accent-colored laser atmosphere."


#### Dither Laser Dark Mode Skill

##### Use When
- Create a dark premium design system that combines near-black surfaces, subtle ordered-dither texture, and a thin accent-colored laser atmosphere.

##### Workflow

##### Scope
- Apply this as a full design-system direction across background, surfaces, panels, controls, spacing, borders, and motion.
- Use it when the interface should feel premium, technical, atmospheric, and dark, with a restrained laser motif and subtle dither texture.
- This is not just a background effect. The whole UI should feel unified around dark-mode depth, precise framing, and luminous accent restraint.

##### Visual target
- Build the interface on a near-black or charcoal foundation with premium dark surfaces layered above it.
- Introduce a subtle ordered-dither, coarse pixel, or soft digital grain texture in the background or low-priority surface layers so the darkness feels material instead of flat.
- Use a thin laser beam or scanning-line atmosphere as a focused visual motif, tinted with the design's primary or strongest accent color rather than a hardcoded blue.
- Keep the laser cinematic and restrained: a narrow white-hot core, soft accent halo, and light volumetric haze or bloom around it, not a thick neon bar.
- Pair the atmospheric background with crisp panels, glass-dark cards, muted strokes, border gradients, and selective glow so the UI feels like a polished command surface.

##### Implementation guidance
- Use dark surfaces with subtle tonal separation: deep black base, slightly lifted panels, quiet translucent overlays, and thin white or accent-tinted borders.
- Apply dither or grain sparingly in the backdrop, large empty regions, or secondary fills. It should add texture and mood without making the interface noisy or retro-gamey.
- If using WebGL, canvas, or shader layers, keep them fixed behind the UI with `pointer-events: none` and place content on a higher stacking context.
- Derive the laser glow, smoky haze, or bloom from the active accent color, but keep the brightest laser core close to white for clarity.
- Use the laser as a compositional anchor: center line, offset beam, corner convergence, or background sweep. It should support hierarchy, not overpower content.
- Panels, dashboards, and navigation should use precise spacing, subtle blur, dim highlights, and understated elevation rather than loud glassmorphism or generic cards.

##### Recommended patterns
- Floating dark nav shells with backdrop blur, thin borders, and restrained accent activity states.
- Framed dashboard containers with corner markers, fine grid lines, or vertical boundary rules over a softly dithered dark field.
- Dark glass or near-opaque cards using one-pixel gradient borders, soft shadows, and limited accent glows.
- Thin laser or beam motif behind the hero area, around a central axis, or converging near a focal region with faint smoke or haze.
- Data surfaces that stay legible with white or neutral text, while the accent color appears in status chips, active tabs, icons, progress bars, or focal controls.

##### Tuning knobs
- Dither density: keep the texture visible enough to enrich the background, but quiet enough that it disappears behind content.
- Laser intensity: separate beam thickness from halo width so the beam stays thin while the glow can breathe softly.
- Accent restraint: use the brand color selectively and let neutral dark tones dominate the system.
- Surface contrast: tune the gap between page background, panels, and overlays so the interface has depth without becoming muddy.
- Atmosphere: add haze, bloom, and fog only around focal laser areas instead of filling the whole screen.

##### Avoid
- Thick neon laser bars, overwhelming bloom, or full-frame fog that destroys readability.
- Hardcoding indigo or cyan when the design clearly uses another accent color.
- Heavy dither everywhere, which makes the interface dirty, retro, or low-resolution instead of premium.
- Flat black layouts with no texture, depth, or material separation.
- Generic SaaS cards and gradients that ignore the laser-plus-dither visual system.


---

### mesh-gradient-dark-blue-clean
**Description:** Create a futuristic, premium, clean dark-blue mesh-gradient design system across background rendering, hero shell, navigation, floating nodes, framed sections, CTAs, and motion. Use when the interface needs a near-black navy foundation, procedural blue mesh atmosphere, disciplined minimal structure, and infrastructural or planetary depth.


#### Mesh Gradient Dark Blue Clean

##### Use When
- The whole page should feel futuristic, premium, clean, and infrastructural.
- A dark-blue mesh gradient should power the composition, not sit behind it as a generic backdrop.
- The interface needs a central hero shell, restrained navigation, floating network hints, framed sections, and slow technical motion.

##### Direction
Build on a near-black foundation with a deep navy or steel-blue undertone. Place a shader-like mesh gradient, CPPN-style field, abstract WebGL veil, or canvas light field inside the main hero shell. Keep the surrounding system disciplined: crisp typography, thin rails, corner markers, tiny status dots, quiet frames, and sparse node callouts.

This is not an airy blue page. This is not generic glassmorphism. The mesh is the visual engine inside a minimal system shell.

##### System Recipe
1. Foundation: near-black navy, not flat black.
2. Hero shell: large rounded container with a subtle white-to-transparent gradient border and darker inner fill.
3. Mesh field: blue-led procedural canvas or WebGL layer inside the shell.
4. Typography: white headlines, gray-blue support copy, restrained accents.
5. Navigation: compact dark translucent pill with light edge gradient.
6. Nodes: a few floating glass pills, active dots, tiny labels, and connector lines.
7. Structure: thin vertical rails, corner squares, numeric markers, and framed lower sections.
8. CTAs: one bright solid capsule plus one ghost or glass capsule with a faint border gradient.
9. Motion: slow mesh drift, subtle scan streaks, masked text reveal, or tiny node shimmer.

##### Color Tokens

```css
:root {
  --mesh-bg: #030712;
  --mesh-bg-blue: #07111f;
  --mesh-shell: rgba(7, 13, 25, 0.82);
  --mesh-shell-inner: rgba(4, 9, 18, 0.72);
  --mesh-line: rgba(191, 219, 254, 0.14);
  --mesh-line-strong: rgba(226, 232, 240, 0.28);
  --mesh-text: #f8fafc;
  --mesh-copy: #9fb2ca;
  --mesh-muted: #64748b;
  --mesh-accent: #dbeafe;
  --mesh-cobalt: #1d4ed8;
  --mesh-indigo: #312e81;
  --mesh-steel: #385a7c;
}
```

##### Page Foundation

```css
.mesh-page {
  min-height: 100vh;
  color: var(--mesh-text);
  background:
    radial-gradient(circle at 50% 0%, rgba(29, 78, 216, 0.18), transparent 34rem),
    linear-gradient(180deg, var(--mesh-bg-blue), var(--mesh-bg) 48%, #01030a);
}

.mesh-page::selection {
  color: #020617;
  background: var(--mesh-accent);
}
```

##### Hero Shell
Use a border-gradient wrapper and a darker content surface. The mesh canvas sits behind the content inside the shell.

```css
.mesh-shell {
  position: relative;
  overflow: hidden;
  border: 1px solid transparent;
  border-radius: 32px;
  background:
    linear-gradient(var(--mesh-shell), var(--mesh-shell)) padding-box,
    linear-gradient(145deg, rgba(255, 255, 255, 0.46), rgba(147, 197, 253, 0.18), rgba(255, 255, 255, 0.04)) border-box;
  box-shadow:
    0 40px 100px rgba(0, 0, 0, 0.42),
    inset 0 1px 0 rgba(255, 255, 255, 0.10);
}

.mesh-shell__field {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0.78;
  pointer-events: none;
}

.mesh-shell__content {
  position: relative;
  z-index: 2;
  min-height: clamp(560px, 72vh, 820px);
  padding: clamp(28px, 6vw, 84px);
  background:
    linear-gradient(180deg, rgba(4, 9, 18, 0.22), rgba(4, 9, 18, 0.62)),
    var(--mesh-shell-inner);
}
```

```html
<section class="mesh-shell">
  <canvas class="mesh-shell__field" data-dark-blue-mesh></canvas>
  <div class="mesh-shell__content">
    <nav class="mesh-nav">...</nav>
    <h1>Infrastructure for intelligent interfaces.</h1>
    <p>...</p>
  </div>
</section>
```

##### Canvas Mesh Field
Use WebGL or Three.js for the final build when available. This 2D canvas pattern is a good fallback for warped gradients, soft mesh movement, and smoky blue highlights.

```js
function initDarkBlueMesh(canvas) {
  const ctx = canvas.getContext("2d");
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let width = 0;
  let height = 0;
  let frame = 0;
  let rafId = 0;

  const points = [
    { x: 0.18, y: 0.30, r: 0.45, color: "rgba(29, 78, 216, 0.55)" },
    { x: 0.68, y: 0.22, r: 0.38, color: "rgba(49, 46, 129, 0.58)" },
    { x: 0.78, y: 0.72, r: 0.52, color: "rgba(56, 90, 124, 0.48)" },
    { x: 0.42, y: 0.58, r: 0.34, color: "rgba(219, 234, 254, 0.18)" },
  ];

  function resize() {
    const rect = canvas.getBoundingClientRect();
    const dpr = Math.min(window.devicePixelRatio || 1, 1.5);
    width = Math.max(1, rect.width);
    height = Math.max(1, rect.height);
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  function draw(time = 0) {
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = "#030712";
    ctx.fillRect(0, 0, width, height);
    ctx.globalCompositeOperation = "screen";

    points.forEach((point, index) => {
      const drift = reduceMotion ? 0 : Math.sin(time * 0.00018 + index) * 24;
      const x = point.x * width + drift;
      const y = point.y * height + Math.cos(time * 0.00016 + index) * 18;
      const radius = Math.max(width, height) * point.r;
      const gradient = ctx.createRadialGradient(x, y, 0, x, y, radius);
      gradient.addColorStop(0, point.color);
      gradient.addColorStop(1, "rgba(3, 7, 18, 0)");
      ctx.fillStyle = gradient;
      ctx.fillRect(0, 0, width, height);
    });

    ctx.globalCompositeOperation = "source-over";
    ctx.fillStyle = "rgba(255, 255, 255, 0.035)";
    for (let y = (frame % 28); y < height; y += 28) {
      ctx.fillRect(0, y, width, 1);
    }

    frame += 1;
    if (!reduceMotion) rafId = requestAnimationFrame(draw);
  }

  function handleResize() {
    cancelAnimationFrame(rafId);
    resize();
    draw();
  }

  resize();
  draw();
  window.addEventListener("resize", handleResize);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
  };
}
```

##### Navigation

```css
.mesh-nav {
  display: flex;
  align-items: center;
  gap: 6px;
  width: fit-content;
  padding: 6px;
  border: 1px solid transparent;
  border-radius: 999px;
  background:
    linear-gradient(rgba(5, 12, 24, 0.76), rgba(5, 12, 24, 0.76)) padding-box,
    linear-gradient(120deg, rgba(255, 255, 255, 0.28), rgba(96, 165, 250, 0.16), rgba(255, 255, 255, 0.04)) border-box;
  backdrop-filter: blur(18px);
}

.mesh-nav a {
  color: var(--mesh-copy);
  border-radius: 999px;
  padding: 9px 14px;
  text-decoration: none;
}

.mesh-nav a:hover,
.mesh-nav a[aria-current="page"] {
  color: var(--mesh-text);
  background: rgba(255, 255, 255, 0.08);
}
```

##### Nodes And Rails

```css
.mesh-node {
  position: absolute;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: 1px solid rgba(191, 219, 254, 0.18);
  border-radius: 999px;
  padding: 7px 10px;
  color: var(--mesh-copy);
  background: rgba(5, 12, 24, 0.58);
  backdrop-filter: blur(14px);
  font-size: 12px;
}

.mesh-node::before {
  content: "";
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #bfdbfe;
  box-shadow: 0 0 18px rgba(147, 197, 253, 0.72);
}

.mesh-rail {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 1px;
  background: linear-gradient(180deg, transparent, var(--mesh-line), transparent);
}

.mesh-corner {
  position: absolute;
  width: 6px;
  height: 6px;
  background: var(--mesh-line-strong);
}
```

##### CTA Pair

```css
.mesh-cta-primary {
  color: #020617;
  background: #f8fafc;
  box-shadow: 0 16px 36px rgba(219, 234, 254, 0.18);
}

.mesh-cta-secondary {
  color: var(--mesh-text);
  border: 1px solid transparent;
  background:
    linear-gradient(rgba(5, 12, 24, 0.62), rgba(5, 12, 24, 0.62)) padding-box,
    linear-gradient(135deg, rgba(255, 255, 255, 0.28), rgba(96, 165, 250, 0.12), rgba(255, 255, 255, 0.04)) border-box;
}
```

##### Motion Defaults
- Mesh drift: very slow, 12s to 28s loops, no sharp easing.
- Scan streaks: sparse vertical drops or horizontal lines, low opacity.
- Text: masked reveal on hero headline and section labels only.
- Nodes: shimmer or pulse at low intensity, not constant blinking.
- Reduced motion: freeze mesh, remove shimmer, keep layout and contrast intact.

##### Tuning Knobs
- Mesh visibility: increase opacity only until mood is legible; copy stays primary.
- Blue hue: shift between indigo, navy, cobalt, and steel blue while preserving the dark base.
- Shell contrast: tune outer border, inner fill, and canvas opacity until layers feel crisp.
- Network density: add fewer nodes for luxury, more markers for technical infrastructure.
- Motion intensity: slow and atmospheric, never game-like.

##### Avoid
- Flat CSS gradients with no mesh-like depth or procedural character.
- Bright cyan overload or electric-blue glow everywhere.
- Crowded dashboards, excessive floating widgets, or competing cards.
- Generic translucent blobs with no rails, frames, markers, or system structure.
- Overbuilt shader effects that reduce readability.
- Airy light-blue sections that break the dark premium atmosphere.

##### Quick Checks
- The mesh is visible inside the hero shell and feels dimensional.
- The foundation reads near-black navy, not flat black or bright blue.
- The shell has a crisp border-gradient edge and darker inner surface.
- Typography remains bright, sharp, and readable over the field.
- Nodes, rails, markers, and scan lines are sparse and aligned.
- CTAs have clear contrast: solid primary, glass secondary.


---

### background-grid-webgl
**Description:** "Create a perspective WebGL background grid with fading lines, subtle particle haze, slow forward drift, and gentle camera parallax."


#### Background Grid WebGL Skill

##### Use When
- Create a perspective WebGL background grid with fading lines, subtle particle haze, slow forward drift, and gentle camera parallax.

##### Workflow

##### Scope
- Apply this only to the immersive background grid layer, not to the full page layout, copy, or unrelated particle or laser systems.
- Use it when the design needs a perspective tech grid receding into space with subtle motion and depth.

##### Visual target
- Create a large perspective ground-plane grid viewed from an elevated camera angle so the lines recede toward the horizon.
- Keep the grid understated and atmospheric: thin lines, soft fade with distance, dark background, and restrained glow rather than a loud retro neon floor.
- Add a light field of floating particles or dust to give the scene depth without overpowering the grid.
- Use the design's primary color or strongest accent color sparingly for glow, particles, or secondary emphasis. If the design is neutral, a white or cool gray grid is acceptable.

##### Implementation guidance
- Prefer Three.js or equivalent real WebGL rendering for this effect.
- Use a perspective camera positioned above the plane and looking toward the origin to emphasize depth.
- Build the grid as a large plane helper or custom grid with line opacity fading by distance so the far field dissolves smoothly.
- Animate the grid with slow forward drift or repeated positional cycling so it feels alive without becoming distracting.
- Add subtle mouse-responsive camera parallax or offset, but keep the movement calm and damped.
- Add a sparse additive particle field with low opacity and slow motion to soften the empty space around the grid.

##### Tuning knobs
- Grid density: control plane size, division count, and line spacing.
- Fade: adjust opacity falloff so the grid recedes naturally into darkness.
- Motion: tune forward drift speed, particle float speed, and camera smoothing.
- Camera: adjust height, distance, tilt, and parallax strength to control perspective drama.
- Color: keep the base grid subtle and use the active design accent only as a restrained highlight.

##### Avoid
- Bright synthwave neon grids unless the design explicitly calls for that style.
- Thick linework or high-contrast grids that compete with foreground content.
- Dense particles or fog that obscure the grid structure.
- Aggressive mouse tracking or fast grid motion that makes the background feel unstable.


---

### bright-green-tech-system-webgl
**Description:** "Create a bright-green technical design system with structured split layouts, hard-framed dark surfaces, mono utility labels, and a prominent WebGL visualization zone."


#### Bright Green Tech System WebGL Skill

##### Use When
- Create a bright-green technical design system with structured split layouts, hard-framed dark surfaces, mono utility labels, and a prominent WebGL visualization zone.

##### Workflow

##### Scope
- Apply this as a full design-system direction across layout, framing, typography, controls, metadata, and the embedded WebGL visualization region.
- Use it when the interface should feel sharply technical, experimental, and structured, with a bright green signal color and a visible real-time visual engine.
- This is not generic dark SaaS and not soft glassmorphism. It should feel like an active synthesis console or build-system interface.

##### Visual target
- Build the page on a deep charcoal or near-black base with highly visible structure lines, container borders, corner brackets, and internal dividers.
- Use a bright lime, acid green, or signal-green accent as the dominant active color for indicators, progress states, focus details, highlights, and important labels.
- Keep the green vivid and intentional, but limit its usage to signals, focal typography, accent fills, and WebGL highlights rather than flooding every surface.
- Establish a split composition where one side carries content, metadata, and instructions while the other side hosts a WebGL or Three.js visualization zone.
- The WebGL region should feel integrated into the system, not decorative: it should read like a powered instrument panel, synthesized globe, particle engine, or live geometry viewport.

##### Implementation guidance
- Prefer a strong outer container shell with thin strokes, subtle backdrop blur, visible corner brackets, and a central divider or explicit split between text and visualization.
- Use clean sans-serif typography for main content and mono utility text for labels, status readouts, process steps, percentages, and system metadata.
- Introduce small framed modules, tips panels, progress rails, or status blocks with precise spacing and clear border hierarchy.
- Use masked staggered reveals, fade-up blocks, or controlled sequencing so the layout feels alive but disciplined.
- Treat the WebGL panel as a core component: use real canvas or Three.js rendering when possible, with luminous particles, synthetic geometry, or orbital forms tinted by the bright green accent.
- Keep the visualization atmospheric and premium: additive glow, subtle fog, gentle camera motion, and calm mouse response are good; chaotic motion and noisy overload are not.

##### Recommended patterns
- Split-screen hero with content and system prompts on the left, immersive WebGL viewport on the right.
- Hard-edged framed container with outer border, inset dividers, and small bracket marks on the corners.
- Mono process navigation using numbered stages, system tags, or compilation steps with one active green state.
- Progress bars, tiny live dots, and status summaries that use bright green as the active operational color.
- WebGL scenes built from luminous particles, planetary structures, node fields, or geometric motion that echo the interface accent color.

##### Tuning knobs
- Green brightness: keep it vivid and high-energy, but balance it against dark neutrals so the page stays premium.
- Structural density: increase or reduce guides, brackets, dividers, and framed boxes depending on how instrumented the system should feel.
- WebGL prominence: choose whether the visualization is a dominant half-screen feature or a more contained technical panel.
- Motion intensity: keep motion smooth and intentional; tune reveal timing, particle speed, and hover response so the system feels alive without becoming frantic.
- Background texture: use faint diagonal or grid texture to enrich the shell, but keep it secondary to the core structure.

##### Avoid
- Generic green-on-black hacker aesthetics with no layout discipline.
- Oversaturating the whole UI with bright green until the interface loses hierarchy.
- Treating WebGL as a random hero decoration disconnected from the design system.
- Soft rounded consumer-app styling that fights the sharp framed technical shell.
- Excessively noisy particles, fast motion, or too many glowing layers that reduce legibility.


---

