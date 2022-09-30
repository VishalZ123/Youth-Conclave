from django.urls import path
import qr_util.views as views

urlpatterns = [
    path('generate_qr', views.generate_qr),
    path('entry',views.entry),
    path('exit',views.exit),
    path('count', views.count)

]