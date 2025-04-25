
from django.urls import path
from .views import RegisterUserView, LoginAPIView

urlpatterns = [
    path('register/', RegisterUserView.as_view(), name='register'),
    path('login/', LoginAPIView.as_view(), name='login'),
]