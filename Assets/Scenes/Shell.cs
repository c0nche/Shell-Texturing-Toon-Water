// Its my code down below, i wrote it   ↑_(ΦwΦ)Ψ 

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shell : MonoBehaviour
{
    public Mesh shellMesh; // getting mesh for shells to put on
    public Shader shellShader; // getting sheder for shells

    // all those things then passed to the shader
    [Range(1, 100)] 
    public int shellCount = 5; // number of shells

    [Range(0.0f, 1.0f)]
    public float waveAmplitude = 0.1f; // distance between shells

    [Range(1.0f, 10000.0f)]
    public float resolution = 50.0f; // number of pixels

    [Range(1.0f, 100.0f)]
    public float pointDensity = 3.0f; // number of points for voronoi

    private Material ShellMaterial; //initializing material for mesh
    private GameObject[] shells; // intializing list of shells


    void Awake() {
        ShellMaterial = new Material(shellShader); // setting material with shader
        shells = new GameObject[shellCount]; // setting list with shellCount number of elements 

        // This loop serves to create all the shells    °˖✧◝(⁰▿⁰)◜✧˖° 
        for(int i = 0; i < shellCount; i++) {
            shells[i] = new GameObject("Shell " + i.ToString());    // creating new shell

            // creating neccessary things to render it
            shells[i].AddComponent<MeshFilter>();
            shells[i].AddComponent<MeshRenderer>();

            // setting those neccessary properties and setting transform of object script attached to as parent for shell transform
            // ヾ(・ω・*)
            shells[i].GetComponent<MeshFilter>().mesh = shellMesh;
            shells[i].GetComponent<MeshRenderer>().material = ShellMaterial;
            shells[i].transform.SetParent(this.transform, false);

            //setting all properties needed for shader
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Resolution", resolution);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_PointDensity", pointDensity);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellDistance", waveAmplitude);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
        }
        // And voila, you have shells stacked on each other    ⊃｡•́‿•̀｡)⊃━✿✿✿✿✿✿
    }

    void Update() {
        // updating all the properties for the shader
        for(int i = 0; i < shellCount; i++) {
            shells[i].GetComponent<MeshFilter>().mesh = shellMesh;
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Resolution", resolution);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_PointDensity", pointDensity);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellDistance", waveAmplitude);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
        }
    }
}
