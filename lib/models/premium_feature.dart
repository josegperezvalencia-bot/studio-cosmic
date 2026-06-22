enum PremiumFeature {
  export4K('Exportación 4K', 'Exporta en resolución 4K'),
  allEffects('Todos los Efectos', 'Accede a efectos premium'),
  noAds('Sin Anuncios', 'Sin publicidad'),
  aiGeneration('Generación IA', 'Ilimitada con IA'),
  gifExport('Exportación GIF', 'Exporta como GIF'),
  mp4Export('Exportación MP4', 'Exporta como video');

  final String label;
  final String description;

  const PremiumFeature(this.label, this.description);
}
