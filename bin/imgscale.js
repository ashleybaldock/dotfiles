

/*
 * Pixel-y image scaling
 *
 * Scale up by repeating pixels n times in x and y
 *  up 2 = 200%, up 3 = 300%, up 4 = 400%
 *
 * Scale down by only outputting every nth pixel
 *  down 2 = 50%, down 3 = 33%, down 4 = 25%
 *
 * Usage: pixscale [down] <repeat(width)>[x<repeat(height)>]
 *
 *  <repeat(width|height)>: [<x1>[,<x2>,...<xN>]
 *
 *  repeat is a comma separated list of numbers
 *    e.g. 2,6
 *  two numbers sepearated with a dash can be used as shorthand for a range
 *    e.g. 2,6 means 2,3,4,5,6
 *  you probably can't mix both though
 *
 * examples:
 *
 *  single output:
 *     pixscale 1       - same as input                            (same as: pixscale 1x1)
 *     pixscale 2       - 1 image: doubled in width and height     (same as: pixscale 2x2)
 *     pixscale 2x3     - 1 image: width x2, height x3
 *
 *  array output:
 *     pixscale 2,3     - 2 images: 2x2, 3x3
 *     pixscale 2-4     - 3 images: 2x2, 3x3, 4x4                  (same as: pixscale 2,3,4)
 *
 *     pixscale 2,3x2   - 2 images: 2x2, 3x2
 *     pixscale 2,4x3,5 - 4 images: 2x3, 2x5; 4x3, 4x5
 *     pixscale 2,4x3-5 - 6 images: 2x3, 2x4, 2x5; 4x3, 4x4, 4x5
 *     pixscale 2-4x3-5 - 9 images: 2x3, 2x4, 2x5; 3x3, 3x4, 3x5; 4x3, 4x4, 4x5
 *       ...etc.
 *
 *  shortcuts:
 *     pixscale         - generate row of upscaled images          (same as: pixscale 1,2,3,4,5)
 *     pixscale down    - generate row of downscaled images        (same as: pixscale down 1,2,3)
 */


function* upscaleIter(
  source,
  repeatEach = 2,
) {
  for (const s of source) {
    for (let i = repeatEach; i > 0; i--) {
      yield s;
    }
  }
}

sips.images.map((image) => console.log(`${image.size.width}x${image.size.height} - ${image.name}`) || image)
  .map((image, i) => {
    /* imageData: [R, G, B, A, ...] */
    const { size, name } = image;
    const { width, height } = size,
        source = new Canvas(width, height);
    const bytesperpix = 4;
    const pixperpix = 2; // 3, 4, 5, etc.
    const outWidth = width * pixperpix,
          outHeight = height * pixperpix;
    const outCanvas = new Canvas(outWidth, outHeight);
    console.log(source.getImageData(0, 0, height, width).data);
    source.drawImage(image, 0, 0) ;
    console.log(source.getImageData(0, 0, height, width).data);

    var pic = new Uint8ClampedArray(source.getImageData(0, 0, height, width).data);
    for (let j = 0; j < height; ++j) {
      for (let i = 0; i < width; ++i) {
        let p = (j * width + i) * bytesperpix;
        let r = pic[p];
        let g = pic[p+1];
        let b = pic[p+2];
        let a = pic[p+3];
        const fillStyle = `rgb(${r},${g},${b},${a/255})`;
        // const fillStyle = `rgba(${r},${g},${b},1)`;
        console.log(`(${j},${i},${p}), ${a}, ${fillStyle}`);
        outCanvas.fillStyle = fillStyle;
        outCanvas.font = '12pt Menlo';
        outCanvas.fillText('Hello', 0, 0);
        // outCanvas.fillRect(i * bytesperpix, j * bytesperpix, pixperpix, pixperpix);
        outCanvas.fillRect(i * pixperpix, outHeight - ((j - 1) * pixperpix), pixperpix, pixperpix);
      }
    }

    // const outData = outCanvas.createImageData();
    new Output(source, `testout${name}-${i}--src.png`).addToQueue();

    new Output(outCanvas, `testout${name}-${i}.png`).addToQueue();
});


false && sips.images.map((image) => console.log(`${image.size.width}x${image.size.height} - ${image.name}`) || image)
  .map((image, i) => {
    /* imageData: [R, G, B, A, ...] */
    const { size, name } = image;
    const { width, height } = size,
        source = new Canvas(width, height);
    // const bytesperpix = data.byteLength / (width * height)
    const bytesperpix = 4;
    const pixperpix = 2; // 3, 4, 5, etc.
    const outWidth = width * pixperpix,
          outHeight = height * pixperpix;
    const outCanvas = new Canvas(outWidth, outHeight);

    source.drawImage(image, 0, 0);
    (new Output(source, `testout${name}-${i}--src.png`)).addToQueue();
    console.log(source.data.toBuffer('image/png'));
    const inData = source.createImageData();

    const {data} = inData;

    const fromPixels = new Uint32Array(data.buffer);
    
    // const pixIter = Uint8ClampedArray.from(upscaleIter(data.entries(), 2))
    const arrayBuffer = new ArrayBuffer(outWidth * outHeight * bytesperpix);

    /* Endianness doesn't matter when copying whole pixels,
     * but this would need to be accounted for if modifying them */
    const outBytes = new Uint8ClampedArray(arrayBuffer);
    const outPixels = new Uint32Array(arrayBuffer);

    for (let j = 0; j < height; ++j) {
      const fromline = fromPixels.subarray(j * width, (j + 1) * width);
      console.log(fromline);
      const toline = outPixels.subarray(j * outWidth, (j + 1) * outWidth);
      for (let i = 0; i < width; ++i) {
        for (let n = 0; n < pixperpix; ++n) {
          toline.fill(fromline[i], i * n, (i + 1) * n)
        }
      }
      for (let x = 1; x < pixperpix; ++x) {
        const line = outPixels.subarray((j + x) * outWidth, (j + x + 1) * outWidth);
        line.set(toline);
      }
    }

    const outData = outCanvas.createImageData();
    outData.data = outBytes;
    // outCanvas.drawImage(outBytes, 0, 0);
    // const outData = {data: [...outBytes], width: outWidth, height: outHeight};
    // outCanvas.putImageData(outData, 0, 0)
    (new Output(outCanvas, `testout${name}-${i}.png`)).addToQueue();
    console.log(outData);
});

