function validateImageMimeType(base64String) {
  const header = base64String.slice(0, 20);
  if (header.startsWith('/9j/')) return 'image/jpeg';
  if (header.startsWith('iVBORw0KGgo')) return 'image/png';
  if (header.startsWith('R0lGOD')) return 'image/gif';
  if (header.startsWith('UklGR')) return 'image/webp';
  throw new Error('❌ Invalid image MIME type: must be jpeg, png, gif, or webp');
}

// Piemērs lietojumam:
try {
  const mimeType = validateImageMimeType(imageBase64);
  payload.image.source.base64.media_type = mimeType;
} catch (err) {
  console.error(err.message);
  process.exit(1);
}
