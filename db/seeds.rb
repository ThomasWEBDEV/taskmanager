# Nettoyage de la base de données
puts "🧹 Nettoyage de la base de données..."
Task.destroy_all
Project.destroy_all
User.destroy_all

puts "✅ Base de données nettoyée!"

# Création des utilisateurs de démo
puts "👤 Création des utilisateurs..."

demo_user = User.create!(
  email: "demo@taskmanager.com",
  password: "password123",
  password_confirmation: "password123"
)

john = User.create!(
  email: "john.doe@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "✅ #{User.count} utilisateurs créés!"

# Projets pour l'utilisateur de démo
puts "📁 Création des projets..."

# Projet 1 : Application Mobile
mobile_project = Project.create!(
  user: demo_user,
  title: "Application Mobile E-commerce",
  description: "Développement d'une application mobile React Native pour notre plateforme e-commerce. Features : panier, paiement sécurisé, notifications push."
)

# Projet 2 : Refonte Site Web
web_project = Project.create!(
  user: demo_user,
  title: "Refonte Site Web Corporate",
  description: "Migration du site corporate de WordPress vers Next.js avec headless CMS. Amélioration des performances et du SEO."
)

# Projet 3 : API REST
api_project = Project.create!(
  user: demo_user,
  title: "API REST Microservices",
  description: "Architecture microservices avec Node.js et GraphQL. Intégration de Redis pour le cache et RabbitMQ pour la messagerie."
)

# Projet 4 : Dashboard Analytics
dashboard_project = Project.create!(
  user: demo_user,
  title: "Dashboard Analytics",
  description: "Tableau de bord temps réel avec Vue.js et WebSockets. Visualisation de données avec D3.js et Chart.js."
)

# Projet 5 : Migration Cloud
cloud_project = Project.create!(
  user: demo_user,
  title: "Migration Cloud AWS",
  description: "Migration de l'infrastructure on-premise vers AWS. Mise en place de Kubernetes, monitoring avec Prometheus et Grafana."
)

puts "✅ #{Project.count} projets créés!"

# Création des tâches
puts "📝 Création des tâches..."

# Tâches pour le projet Mobile
[
  { title: "Setup projet React Native", description: "Initialiser le projet avec Expo CLI et configurer l'environnement de développement", completed: true, priority: "urgent", due_date: 2.days.ago },
  { title: "Design système de composants", description: "Créer les composants réutilisables selon le design system", completed: true, priority: "high", due_date: 1.day.ago },
  { title: "Intégration API authentification", description: "JWT tokens, refresh tokens, biométrie", completed: true, priority: "urgent", due_date: Date.today },
  { title: "Écran de catalogue produits", description: "Liste avec filtres, tri et recherche instantanée", completed: false, priority: "high", due_date: 2.days.from_now, notes: "Utiliser React Query pour le cache" },
  { title: "Système de panier", description: "Gestion du panier avec persistance locale", completed: false, priority: "high", due_date: 5.days.from_now },
  { title: "Intégration Stripe", description: "Paiement sécurisé avec Apple Pay et Google Pay", completed: false, priority: "urgent", due_date: 7.days.from_now, notes: "Voir documentation Stripe Connect" },
  { title: "Push notifications", description: "Firebase Cloud Messaging pour iOS et Android", completed: false, priority: "normal", due_date: 10.days.from_now }
].each do |task_data|
  Task.create!(task_data.merge(project: mobile_project, user: demo_user))
end

# Tâches pour le projet Web
[
  { title: "Audit performance actuel", description: "Lighthouse audit et identification des bottlenecks", completed: true, priority: "high", due_date: 3.days.ago },
  { title: "Architecture Next.js", description: "Setup avec TypeScript, ESLint et Prettier", completed: true, priority: "urgent", due_date: 2.days.ago },
  { title: "Migration contenu CMS", description: "Export WordPress vers Strapi headless CMS", completed: false, priority: "urgent", due_date: Date.tomorrow, notes: "Script de migration Python prêt" },
  { title: "SEO technique", description: "Sitemap dynamique, robots.txt, meta tags", completed: false, priority: "high", due_date: 3.days.from_now },
  { title: "Optimisation images", description: "WebP, lazy loading, responsive images", completed: false, priority: "normal", due_date: 5.days.from_now },
  { title: "Tests E2E Cypress", description: "Couverture des parcours critiques", completed: false, priority: "high", due_date: 7.days.from_now }
].each do |task_data|
  Task.create!(task_data.merge(project: web_project, user: demo_user))
end

# Tâches pour l'API
[
  { title: "Architecture microservices", description: "Design patterns: API Gateway, Service Discovery", completed: true, priority: "urgent", due_date: 5.days.ago },
  { title: "Service authentification", description: "OAuth2, OpenID Connect, MFA", completed: true, priority: "urgent", due_date: 3.days.ago },
  { title: "Service produits", description: "CRUD avec pagination et filtres", completed: true, priority: "high", due_date: 2.days.ago },
  { title: "GraphQL Gateway", description: "Apollo Federation pour agréger les microservices", completed: false, priority: "high", due_date: Date.today, notes: "Schema stitching vs Federation" },
  { title: "Cache Redis", description: "Stratégie de cache et invalidation", completed: false, priority: "high", due_date: 2.days.from_now },
  { title: "Message Queue", description: "RabbitMQ pour traitement asynchrone", completed: false, priority: "normal", due_date: 4.days.from_now },
  { title: "Monitoring et logging", description: "ELK Stack et Prometheus", completed: false, priority: "high", due_date: 6.days.from_now },
  { title: "Documentation OpenAPI", description: "Swagger UI pour tous les endpoints", completed: false, priority: "normal", due_date: 8.days.from_now }
].each do |task_data|
  Task.create!(task_data.merge(project: api_project, user: demo_user))
end

# Tâches pour le Dashboard
[
  { title: "Wireframes UX", description: "Figma mockups validés par le client", completed: true, priority: "high", due_date: 7.days.ago },
  { title: "Setup Vue 3 + Vite", description: "Configuration avec Composition API", completed: true, priority: "urgent", due_date: 5.days.ago },
  { title: "WebSocket serveur", description: "Socket.io pour temps réel", completed: false, priority: "urgent", due_date: Date.today, notes: "Scaling horizontal avec Redis adapter" },
  { title: "Charts dynamiques", description: "Intégration Chart.js et D3.js", completed: false, priority: "high", due_date: 2.days.from_now },
  { title: "Export PDF/Excel", description: "Génération de rapports", completed: false, priority: "normal", due_date: 5.days.from_now },
  { title: "Mode sombre", description: "Theme switcher avec persistance", completed: false, priority: "normal", due_date: 7.days.from_now }
].each do |task_data|
  Task.create!(task_data.merge(project: dashboard_project, user: demo_user))
end

# Tâches pour la migration Cloud
[
  { title: "Audit infrastructure actuelle", description: "Inventaire serveurs, dépendances et coûts", completed: true, priority: "urgent", due_date: 10.days.ago },
  { title: "Architecture AWS", description: "VPC, Subnets, Security Groups", completed: true, priority: "urgent", due_date: 7.days.ago },
  { title: "Terraform IaC", description: "Infrastructure as Code pour tous les environnements", completed: false, priority: "high", due_date: Date.today, notes: "Modules réutilisables" },
  { title: "Migration base de données", description: "RDS PostgreSQL avec Read Replicas", completed: false, priority: "urgent", due_date: 2.days.from_now },
  { title: "Setup Kubernetes EKS", description: "Cluster K8s managé avec auto-scaling", completed: false, priority: "high", due_date: 4.days.from_now },
  { title: "CI/CD Pipeline", description: "GitHub Actions vers AWS ECR et EKS", completed: false, priority: "high", due_date: 6.days.from_now },
  { title: "Monitoring Prometheus", description: "Métriques et alertes", completed: false, priority: "normal", due_date: 8.days.from_now },
  { title: "Backup strategy", description: "Snapshots automatiques et disaster recovery", completed: false, priority: "high", due_date: 10.days.from_now }
].each do |task_data|
  Task.create!(task_data.merge(project: cloud_project, user: demo_user))
end

# Stats finales
puts "\n📊 Résumé de la seed:"
puts "  👤 Utilisateurs: #{User.count}"
puts "  📁 Projets: #{Project.count}"
puts "  ✅ Tâches terminées: #{Task.where(completed: true).count}"
puts "  ⏳ Tâches en cours: #{Task.where(completed: false).count}"
puts "  🔥 Tâches urgentes: #{Task.where(priority: 'urgent').count}"
puts "  ⚡ Tâches importantes: #{Task.where(priority: 'high').count}"
puts "\n🎉 Seed terminée avec succès!"
puts "\n📧 Compte de démo:"
puts "  Email: demo@taskmanager.com"
puts "  Mot de passe: password123"
