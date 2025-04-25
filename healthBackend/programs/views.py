from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from programs.models import Program
from programs.serializers import ProgramSerializer
from accounts.models import ClientProfile, DoctorProfile  

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



class GetOneOrAllProgramsAPIView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, name=None):
        if name:
            # Fetch a single program by name
            try:
                program = Program.objects.get(name=name)
                serializer = ProgramSerializer(program)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Program.DoesNotExist:
                return Response({'error': 'Program not found'}, status=status.HTTP_404_NOT_FOUND)
        else:
            # Fetch all programs
            programs = Program.objects.all()
            serializer = ProgramSerializer(programs, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        

class AddClientToProgramAPIView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the doctor is authenticated

    def post(self, request):
      
        client_id = request.data.get('client_id')
        program_ids = request.data.get('program_ids', [])  

        if not client_id or not program_ids:
            return Response({"error": "Client ID and program IDs are required."}, status=status.HTTP_400_BAD_REQUEST)

        
        try:
            client = ClientProfile.objects.get(id=client_id)
        except ClientProfile.DoesNotExist:
            return Response({"error": "Client not found."}, status=status.HTTP_404_NOT_FOUND)

        for program_id in program_ids:
            program = get_object_or_404(Program, id=program_id)

            # Ensure the doctor is authorized to add clients to this program
            if program.doctor.user != request.user:
                return Response({"error": f"You are not authorized to add clients to the program with ID {program_id}."},
                                 status=status.HTTP_403_FORBIDDEN)

            # Add the client to the program
            program.clients.add(client)

        return Response({"message": "Client added to the selected programs successfully."}, status=status.HTTP_200_OK)
