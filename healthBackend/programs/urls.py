
from django.urls import path
from .views import CreateProgramAPIView

urlpatterns = [
    path('create-program/', CreateProgramAPIView.as_view(), name='create-program'),
]