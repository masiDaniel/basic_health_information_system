
from django.urls import path
from .views import CreateProgramAPIView, GetOneOrAllProgramsAPIView,  AddClientToProgramAPIView , GetAllRegisteredClientsAPIView

urlpatterns = [
    path('create-program/', CreateProgramAPIView.as_view(), name='create-program'),
    path('programs/', GetOneOrAllProgramsAPIView.as_view(), name='get-all-programs'),
    path('programs/<str:name>/', GetOneOrAllProgramsAPIView.as_view(), name='get-single-program'),
    path('programs/add-client/', AddClientToProgramAPIView.as_view(), name='add-client-to-program'),
    path('clients/', GetAllRegisteredClientsAPIView.as_view(), name='get-all-clients'),
]