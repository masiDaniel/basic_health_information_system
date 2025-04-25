from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from programs.serializers import ProgramSerializer
from accounts.models import DoctorProfile  

class CreateProgramAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            doctor = request.user.doctorprofile
        except DoctorProfile.DoesNotExist:
            return Response({"error": "You must be a doctor to create a program."}, status=status.HTTP_403_FORBIDDEN)

        serializer = ProgramSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Program created successfully"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
